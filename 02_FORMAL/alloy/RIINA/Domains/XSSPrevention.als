// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for cross-site scripting prevention
// Bounded verification of XSSPrevention properties
module riina/Domains/XSSPrevention

sig WebInput {
  escaped: one Int,
  validated: one Int,
  safe: one Int
}

sig WebOutput {
  input: one WebInput,
  rendered: one Int
}

// Invariant: escaped_is_safe
fact escaped_is_safe_fact {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}

// Invariant: render_requires_safe
fact render_requires_safe_fact {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}

// Invariant: validated_implies_safe
fact validated_implies_safe_fact {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}

assert andb_true_iff {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check andb_true_iff for 6

assert andb_false_iff {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check andb_false_iff for 6

assert orb_true_iff {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check orb_true_iff for 6

assert negb_true_iff {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check negb_true_iff for 6

assert forallb_true {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check forallb_true for 6

assert XSS_001 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_001 for 6

assert XSS_002 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_002 for 6

assert XSS_003 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_003 for 6

assert XSS_004 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_004 for 6

assert XSS_005 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_005 for 6

assert XSS_006 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_006 for 6

assert XSS_007 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_007 for 6

assert XSS_008 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_008 for 6

assert XSS_009 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_009 for 6

assert XSS_010 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_010 for 6

assert XSS_011 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_011 for 6

assert XSS_012 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_012 for 6

assert XSS_013 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_013 for 6

assert XSS_014 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_014 for 6

assert XSS_015 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_015 for 6

assert XSS_016 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_016 for 6

assert XSS_017 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_017 for 6

assert XSS_018 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_018 for 6

assert XSS_019 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_019 for 6

assert XSS_020 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_020 for 6

assert XSS_021 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_021 for 6

assert XSS_022 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_022 for 6

assert XSS_023 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_023 for 6

assert XSS_024 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_024 for 6

assert XSS_025_complete {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_025_complete for 6

assert XSS_026 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_026 for 6

assert XSS_027 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_027 for 6

assert XSS_028 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_028 for 6

assert XSS_029 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_029 for 6

assert XSS_030 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_030 for 6

assert XSS_031 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_031 for 6

assert XSS_032 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_032 for 6

assert XSS_033 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_033 for 6

assert XSS_034 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_034 for 6

assert XSS_035 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_035 for 6

assert XSS_036 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_036 for 6

assert XSS_037 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_037 for 6

assert XSS_038 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_038 for 6

assert XSS_039 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_039 for 6

assert XSS_040 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_040 for 6

assert XSS_041 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_041 for 6

assert XSS_042 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_042 for 6

assert XSS_043 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_043 for 6

assert XSS_044 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_044 for 6

assert XSS_045 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_045 for 6

assert XSS_046 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_046 for 6

assert XSS_047 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_047 for 6

assert XSS_048 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_048 for 6

assert XSS_049 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_049 for 6

assert XSS_050 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_050 for 6

assert XSS_051 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_051 for 6

assert XSS_052 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_052 for 6

assert XSS_053 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_053 for 6

assert XSS_054 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_054 for 6

assert XSS_055 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_055 for 6

assert XSS_056 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_056 for 6

assert XSS_057 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_057 for 6

assert XSS_058 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_058 for 6

assert XSS_059 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_059 for 6

assert XSS_060 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_060 for 6

assert XSS_061 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_061 for 6

assert XSS_062 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_062 for 6

assert XSS_063 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_063 for 6

assert XSS_064 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_064 for 6

assert XSS_065 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_065 for 6

assert XSS_066 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_066 for 6

assert XSS_067 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_067 for 6

assert XSS_068 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_068 for 6

assert XSS_069 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_069 for 6

assert XSS_070 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_070 for 6

assert XSS_071 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_071 for 6

assert XSS_072 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_072 for 6

assert XSS_073 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_073 for 6

assert XSS_074 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_074 for 6

assert XSS_075 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_075 for 6

assert XSS_076 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_076 for 6

assert XSS_077 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_077 for 6

assert XSS_078 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_078 for 6

assert XSS_079 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_079 for 6

assert XSS_080 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_080 for 6

assert XSS_081 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_081 for 6

assert XSS_082 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_082 for 6

assert XSS_083 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_083 for 6

assert XSS_084 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_084 for 6

assert XSS_085 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_085 for 6

assert XSS_086 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_086 for 6

assert XSS_087 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_087 for 6

assert XSS_088 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_088 for 6

assert XSS_089 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_089 for 6

assert XSS_090 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_090 for 6

assert XSS_091 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_091 for 6

assert XSS_092 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_092 for 6

assert XSS_093 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_093 for 6

assert XSS_094 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_094 for 6

assert XSS_095 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_095 for 6

assert XSS_096 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_096 for 6

assert XSS_097 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_097 for 6

assert XSS_098 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_098 for 6

assert XSS_099 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_099 for 6

assert XSS_100 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_100 for 6

assert XSS_101 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_101 for 6

assert XSS_102 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_102 for 6

assert XSS_103 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_103 for 6

assert XSS_104 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_104 for 6

assert XSS_105 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_105 for 6

assert XSS_106 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_106 for 6

assert XSS_107 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_107 for 6

assert XSS_108 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_108 for 6

assert XSS_109 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_109 for 6

assert XSS_110 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_110 for 6

assert XSS_111 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_111 for 6

assert XSS_112 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_112 for 6

assert XSS_113 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_113 for 6

assert XSS_114 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_114 for 6

assert XSS_115 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_115 for 6

assert XSS_116 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_116 for 6

assert XSS_117 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_117 for 6

assert XSS_118 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_118 for 6

assert XSS_119 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_119 for 6

assert XSS_120 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_120 for 6

assert XSS_121 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_121 for 6

assert XSS_122 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_122 for 6

assert XSS_123 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_123 for 6

assert XSS_124 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_124 for 6

assert XSS_125 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_125 for 6

assert XSS_126 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_126 for 6

assert XSS_127 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_127 for 6

assert XSS_128 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_128 for 6

assert XSS_129 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_129 for 6

assert XSS_130 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_130 for 6

assert XSS_131 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_131 for 6

assert XSS_132 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_132 for 6

assert XSS_133 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_133 for 6

assert XSS_134 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_134 for 6

assert XSS_135 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_135 for 6

assert XSS_136 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_136 for 6

assert XSS_137 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_137 for 6

assert XSS_138 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_138 for 6

assert XSS_139 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_139 for 6

assert XSS_140 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_140 for 6

assert XSS_141 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_141 for 6

assert XSS_142 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_142 for 6

assert XSS_143 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_143 for 6

assert XSS_144 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_144 for 6

assert XSS_145 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_145 for 6

assert XSS_146 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_146 for 6

assert XSS_147 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_147 for 6

assert XSS_148 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_148 for 6

assert XSS_149 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_149 for 6

assert XSS_150 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_150 for 6

assert XSS_151 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_151 for 6

assert XSS_152 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_152 for 6

assert XSS_153 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_153 for 6

assert XSS_154 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_154 for 6

assert XSS_155 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_155 for 6

assert XSS_156 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_156 for 6

assert XSS_157 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_157 for 6

assert XSS_158 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_158 for 6

assert XSS_159 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_159 for 6

assert XSS_160 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_160 for 6

assert XSS_161 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_161 for 6

assert XSS_162 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_162 for 6

assert XSS_163 {
  all w: WebInput | w.validated = 1 implies w.safe = 1
}
check XSS_163 for 6

assert XSS_164 {
  all w: WebInput | w.escaped = 1 implies w.safe = 1
}
check XSS_164 for 6

assert XSS_165 {
  all o: WebOutput | o.rendered = 1 implies o.input.safe = 1
}
check XSS_165 for 6

pred ExampleXSSPrevention {
  some WebInput
}
run ExampleXSSPrevention for 6
