// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Persistent (structure-sharing) maps, used by the typing context and the
//! store typing Σ ([`crate::StoreTy`]).
//!
//! The typechecker clones its context for every sub-scope — each `biar`, each
//! branch of a `kalau`/`padan`, each lambda — and every clone used to copy
//! every `HashMap` in it, the ~600 builtins included. Nested scopes keep all
//! of those copies alive at once, so a block of n sequential `biar`
//! statements cost O(n²) time and memory (5,000 lines: 2.7 GB and 18 s in a
//! release build; a 10,000-link `lain kalau` chain: 2.3 GB).
//!
//! A [`PMap`] is immutable and shared: cloning it is two `Rc` clones, and an
//! insert or removal only affects the copy it is applied to. The newest
//! entries sit in a short shared list ([`RECENT_MAX`]); when it fills it is
//! folded into an immutable hash-map LEVEL, and equal-weight levels are merged
//! like a binary counter, so there are at most ~log₂(n) levels. A lookup is a
//! bounded list scan plus one hash probe per level; every binding takes part
//! in O(log n) merges, so even with every scope alive at once the total memory
//! is O(n log n), not O(n²).
//!
//! Lookup semantics are those of a `HashMap` updated in place: the NEWEST
//! insert of a key wins (shadowing), and a removal hides every older entry.

use std::borrow::Borrow;
use std::collections::HashMap;
use std::hash::Hash;
use std::rc::Rc;

/// Length of the recent-entries list at which it is folded into a level.
/// Bounds the linear part of a lookup.
const RECENT_MAX: usize = 32;

/// A persistent map. See the module docs.
pub struct PMap<K, V> {
    /// The newest entries, newest first. `None` values are removals.
    recent: Option<Rc<Node<K, V>>>,
    /// Number of nodes in `recent`.
    recent_len: usize,
    /// Older entries folded into immutable maps, newest level first.
    levels: Option<Rc<Level<K, V>>>,
}

struct Node<K, V> {
    key: K,
    val: Option<V>,
    next: Option<Rc<Node<K, V>>>,
}

struct Level<K, V> {
    map: HashMap<K, Option<V>>,
    /// Number of inserts/removals folded into this level (the binary-counter
    /// weight; a key shadowed inside the level still counts).
    weight: usize,
    next: Option<Rc<Level<K, V>>>,
}

impl<K, V> Clone for PMap<K, V> {
    fn clone(&self) -> Self {
        Self {
            recent: self.recent.clone(),
            recent_len: self.recent_len,
            levels: self.levels.clone(),
        }
    }
}

impl<K, V> Default for PMap<K, V> {
    fn default() -> Self {
        Self {
            recent: None,
            recent_len: 0,
            levels: None,
        }
    }
}

impl<K: Eq + Hash + Clone, V: Clone> PMap<K, V> {
    pub fn new() -> Self {
        Self::default()
    }

    /// The value of the newest visible entry for `key`.
    pub fn get<Q>(&self, key: &Q) -> Option<&V>
    where
        K: Borrow<Q>,
        Q: Eq + Hash + ?Sized,
    {
        let mut node = self.recent.as_deref();
        while let Some(n) = node {
            if n.key.borrow() == key {
                return n.val.as_ref();
            }
            node = n.next.as_deref();
        }
        let mut level = self.levels.as_deref();
        while let Some(l) = level {
            if let Some(v) = l.map.get(key) {
                return v.as_ref();
            }
            level = l.next.as_deref();
        }
        None
    }

    pub fn contains_key<Q>(&self, key: &Q) -> bool
    where
        K: Borrow<Q>,
        Q: Eq + Hash + ?Sized,
    {
        self.get(key).is_some()
    }

    /// Bind `key` to `val` in THIS copy (other clones are unaffected).
    pub fn insert(&mut self, key: K, val: V) {
        self.push(key, Some(val));
    }

    /// Hide `key` in THIS copy. A no-op (and no growth) when it is absent.
    pub fn remove<Q>(&mut self, key: &Q)
    where
        K: Borrow<Q>,
        Q: Eq + Hash + ToOwned<Owned = K> + ?Sized,
    {
        if self.contains_key(key) {
            self.push(key.to_owned(), None);
        }
    }

    /// The visible entries (each key once, with its newest value), in no
    /// particular order.
    pub fn iter(&self) -> impl Iterator<Item = (&K, &V)> {
        let mut levels = Vec::new();
        let mut level = self.levels.as_deref();
        while let Some(l) = level {
            levels.push(l);
            level = l.next.as_deref();
        }
        let mut recent = Vec::with_capacity(self.recent_len);
        let mut node = self.recent.as_deref();
        while let Some(n) = node {
            recent.push(n);
            node = n.next.as_deref();
        }
        // Oldest first, so a newer entry (or removal) overwrites an older one.
        let mut visible: HashMap<&K, Option<&V>> = HashMap::new();
        for l in levels.into_iter().rev() {
            for (k, v) in &l.map {
                visible.insert(k, v.as_ref());
            }
        }
        for n in recent.into_iter().rev() {
            visible.insert(&n.key, n.val.as_ref());
        }
        visible.into_iter().filter_map(|(k, v)| v.map(|v| (k, v)))
    }

    fn push(&mut self, key: K, val: Option<V>) {
        self.recent = Some(Rc::new(Node {
            key,
            val,
            next: self.recent.take(),
        }));
        self.recent_len += 1;
        if self.recent_len >= RECENT_MAX {
            self.fold_recent();
        }
    }

    /// Fold the recent list into a new level, merging every level whose
    /// weight does not exceed the new one (binary-counter carries).
    fn fold_recent(&mut self) {
        let mut newest_first = Vec::with_capacity(self.recent_len);
        let mut node = self.recent.as_deref();
        while let Some(n) = node {
            newest_first.push((n.key.clone(), n.val.clone()));
            node = n.next.as_deref();
        }
        let mut map = HashMap::with_capacity(newest_first.len());
        for (k, v) in newest_first.into_iter().rev() {
            map.insert(k, v);
        }
        let mut weight = self.recent_len;
        self.recent = None;
        self.recent_len = 0;

        let mut older = self.levels.take();
        while let Some(head) = older.clone() {
            if head.weight > weight {
                break;
            }
            let mut merged = head.map.clone();
            merged.extend(map);
            map = merged;
            weight += head.weight;
            older = head.next.clone();
        }
        // A removal only has to hide OLDER entries; at the bottom there are none.
        if older.is_none() {
            map.retain(|_, v| v.is_some());
        }
        self.levels = Some(Rc::new(Level {
            map,
            weight,
            next: older,
        }));
    }
}

/// Prints the visible entries, like a `HashMap`.
impl<K: Eq + Hash + Clone + std::fmt::Debug, V: Clone + std::fmt::Debug> std::fmt::Debug
    for PMap<K, V>
{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_map().entries(self.iter()).finish()
    }
}

impl<K: Eq + Hash + Clone, V: Clone> FromIterator<(K, V)> for PMap<K, V> {
    /// One bottom level holding `iter` (later pairs win, as in a `HashMap`).
    fn from_iter<I: IntoIterator<Item = (K, V)>>(iter: I) -> Self {
        let map: HashMap<K, Option<V>> = iter.into_iter().map(|(k, v)| (k, Some(v))).collect();
        if map.is_empty() {
            return Self::default();
        }
        let weight = map.len();
        Self {
            recent: None,
            recent_len: 0,
            levels: Some(Rc::new(Level {
                map,
                weight,
                next: None,
            })),
        }
    }
}

/// A persistent set: a [`PMap`] to `()`.
pub struct PSet<K>(PMap<K, ()>);

impl<K> Clone for PSet<K> {
    fn clone(&self) -> Self {
        Self(self.0.clone())
    }
}

impl<K> Default for PSet<K> {
    fn default() -> Self {
        Self(PMap::default())
    }
}

impl<K: Eq + Hash + Clone> PSet<K> {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn contains<Q>(&self, key: &Q) -> bool
    where
        K: Borrow<Q>,
        Q: Eq + Hash + ?Sized,
    {
        self.0.contains_key(key)
    }

    pub fn insert(&mut self, key: K) {
        if !self.contains(&key) {
            self.0.insert(key, ());
        }
    }

    pub fn remove<Q>(&mut self, key: &Q)
    where
        K: Borrow<Q>,
        Q: Eq + Hash + ToOwned<Owned = K> + ?Sized,
    {
        self.0.remove(key);
    }
}

#[cfg(test)]
mod tests {
    use super::{PMap, PSet, RECENT_MAX};
    use std::collections::HashMap;

    /// Drive a PMap and a reference HashMap through the same operations and
    /// compare every lookup — including across forked (cloned) versions.
    #[test]
    fn matches_an_in_place_hashmap_across_versions() {
        let mut p: PMap<String, usize> = (0..50).map(|i| (format!("b{i}"), i)).collect();
        let mut h: HashMap<String, usize> = (0..50).map(|i| (format!("b{i}"), i)).collect();
        let mut forks = Vec::new();
        for step in 0..5_000usize {
            let key = format!("k{}", (step * 7919) % 613);
            match step % 5 {
                0..=2 => {
                    p.insert(key.clone(), step);
                    h.insert(key, step);
                }
                3 => {
                    p.remove(key.as_str());
                    h.remove(&key);
                }
                _ => {
                    let shadow = format!("b{}", step % 50);
                    p.insert(shadow.clone(), step);
                    h.insert(shadow, step);
                }
            }
            if step % 97 == 0 {
                forks.push((p.clone(), h.clone()));
            }
        }
        forks.push((p, h));
        for (p, h) in &forks {
            for i in 0..613 {
                let k = format!("k{i}");
                assert_eq!(p.get(k.as_str()), h.get(&k), "{k}");
            }
            for i in 0..50 {
                let k = format!("b{i}");
                assert_eq!(p.get(k.as_str()), h.get(&k), "{k}");
            }
            let mut seen: Vec<(String, usize)> = p.iter().map(|(k, v)| (k.clone(), *v)).collect();
            let mut want: Vec<(String, usize)> = h.iter().map(|(k, v)| (k.clone(), *v)).collect();
            seen.sort();
            want.sort();
            assert_eq!(seen, want);
        }
    }

    #[test]
    fn a_fork_does_not_see_later_updates() {
        let mut a: PMap<String, i32> = PMap::new();
        a.insert("x".to_string(), 1);
        let b = a.clone();
        for i in 0..(3 * RECENT_MAX as i32) {
            a.insert("x".to_string(), i + 2);
            a.insert("y".to_string(), i);
        }
        a.remove("y");
        assert_eq!(b.get("x"), Some(&1));
        assert_eq!(b.get("y"), None);
        assert_eq!(a.get("x"), Some(&(3 * RECENT_MAX as i32 + 1)));
        assert_eq!(a.get("y"), None);
    }

    #[test]
    fn levels_stay_logarithmic() {
        let mut p: PMap<usize, usize> = PMap::new();
        for i in 0..100_000 {
            p.insert(i, i);
        }
        let mut levels = 0;
        let mut l = p.levels.as_deref();
        while let Some(level) = l {
            levels += 1;
            l = level.next.as_deref();
        }
        assert!(levels <= 18, "{levels} levels");
        assert!(p.recent_len < RECENT_MAX);
        assert_eq!(p.get(&99_999), Some(&99_999));
    }

    #[test]
    fn set_semantics() {
        let mut s: PSet<String> = PSet::new();
        s.insert("a".to_string());
        let t = s.clone();
        s.remove("a");
        assert!(!s.contains("a"));
        assert!(t.contains("a"));
    }
}
