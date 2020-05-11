[Mesh]
  type = GeneratedMesh
  dim = 2
  elem_type = QUAD4
  nx = 100
  ny = 100
  xmax = 10
  xmin = -10
  ymax = 10
  ymin = -10
  zmax = 0
[]

[AuxKernels]
  [GlobalFreeEnergy]
    type = KKSGlobalFreeEnergy
    fa_name = fm
    fb_name = fb
    variable = Fglobal
    w = 1.0
  []
[]

[AuxVariables]
  [Fglobal]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[BCs]
  [Periodic]
    [BCs]
      auto_direction = 'x y'
      variable = 'cv cg wv wg cv_m cg_m cv_b cg_b'
    []
  []
[]

[Executioner]
  type = Transient
  dt = 0.01
  l_max_its = 100
  nl_max_its = 100
  num_steps = 2000
  petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type'
  petsc_options_value = 'asm      ilu          nonzero'
  solve_type = PJFNK
[]

[ICs]
  [eta]
    type = SmoothCircleIC
    int_width = 0.75
    invalue = 0.9
    outvalue = 0.1
    radius = 3
    variable = eta
    x1 = 0
    y1 = 0
  []
  [cv]
    type = SmoothCircleIC
    int_width = 0.75
    invalue = 0.0042
    outvalue = 0.0042
    radius = 3.0
    variable = cv
    x1 = 0
    y1 = 0
  []
  [cg]
    type = SmoothCircleIC
    int_width = 0.75
    invalue = 0.8
    outvalue = 0.1
    radius = 3.0
    variable = cg
    x1 = 0
    y1 = 0
  []
[]

[Kernels]
  [PhaseConcv]
    type = KKSPhaseConcentration
    c = 'cv'
    ca = 'cv_m'
    eta = 'eta'
    variable = cv_b
  []
  [PhaseConcg]
    type = KKSPhaseConcentration
    c = 'cg'
    ca = 'cg_m'
    eta = 'eta'
    variable = cg_b
  []
  [ChemPotVacancy]
    type = KKSPhaseChemicalPotential
    args_a = 'cg_m'
    args_b = 'cg_b'
    cb = 'cv_b'
    fa_name = fm
    fb_name = fb
    variable = cv_m
  []
  [ChemPotgas]
    type = KKSPhaseChemicalPotential
    args_a = 'cv_m'
    args_b = 'cv_b'
    cb = 'cg_b'
    fa_name = fm
    fb_name = fb
    variable = cg_m
  []
  [CHBulkcv]
    type = KKSSplitCHCRes
    args_a = 'cg_m'
    ca = 'cv_m'
    fa_name = fm
    variable = cv
    w = 'wv'
  []
  [CHBulkcg]
    type = KKSSplitCHCRes
    args_a = 'cv_m'
    ca = 'cg_m'
    fa_name = fm
    variable = cg
    w = 'wg'
  []
  [dcvdt]
    type = CoupledTimeDerivative
    v = 'cv'
    variable = wv
  []
  [dcgdt]
    type = CoupledTimeDerivative
    v = 'cg'
    variable = wg
  []
  [wvkernel]
    type = SplitCHWRes
    mob_name = M
    variable = wv
  []
  [wgkernel]
    type = SplitCHWRes
    mob_name = M
    variable = wg
  []
  [ACBulkF]
    type = KKSACBulkF
    args = 'cv_m cv_b cg_m cg_b'
    fa_name = fm
    fb_name = fb
    variable = eta
    w = 1.0
  []
  [ACBulkCv]
    type = KKSACBulkC
    args = 'cg_m'
    ca = 'cv_m'
    cb = 'cv_b'
    fa_name = fm
    variable = eta
  []
  [ACBulkCg]
    type = KKSACBulkC
    args = 'cv_m'
    ca = 'cg_m'
    cb = 'cg_b'
    fa_name = fm
    variable = eta
  []
  [ACInterface]
    type = ACInterface
    kappa_name = kappa
    variable = eta
  []
  [detadt]
    type = TimeDerivative
    variable = eta
  []
[]

[Materials]
  [h_eta]
    type = SwitchingFunctionMaterial
    eta = 'eta'
    h_order = HIGH
  []
  [g_eta]
    type = BarrierFunctionMaterial
    eta = 'eta'
  []
  [constants]
    type = GenericConstantMaterial
    prop_names = 'M   L   kappa'
    prop_values = '0.7 0.7 1.0  '
  []
  [fm]
    type = DerivativeParsedMaterial
    args = 'cv_m cg_m'
    constant_expressions = '6.4 6.34*1e-8 6.4 6.34*1e-8'
    constant_names = 'A12 eq_cvm B12 eq_cgm'
    f_name = fm
    function = A12*(eq_cvm-cv_m)^2+B12*(eq_cgm-cg_m)^2
  []
  [fb]
    type = DerivativeParsedMaterial
    args = 'cv_b cg_b'
    constant_expressions = '0.96 1.0 2.8 0.7'
    constant_names = 'A22 eq_cvb B22 eq_cgb'
    f_name = fb
    function = 'A22*(eq_cvb-cv_b )^2+B22*(eq_cgb-cg_b)^2'
  []
[]

[Outputs]
  exodus = true
  interval = 10
[]

[Preconditioning]
  [full]
    type = SMP
    full = true
  []
[]

[Variables]
  [eta]
  []
  [cv]
  []
  [cg]
  []
  [wv]
  []
  [wg]
  []
  [cv_m]
  []
  [cg_m]
  []
  [cv_b]
  []
  [cg_b]
  []
[]
