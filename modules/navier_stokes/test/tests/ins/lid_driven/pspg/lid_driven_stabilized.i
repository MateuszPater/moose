[GlobalParams]
  gravity = '0 0 0'
  stabilize = true
  convective_term = false
  integrate_p_by_parts = true
  laplace = true
  u = vel_x
  v = vel_y
  p = p
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 1.0
  ymin = 0
  ymax = 1.0
  nx = 16
  ny = 16
  elem_type = QUAD9
  # elem_type = QUAD4
[]

[MeshModifiers]
  [./corner_node]
    type = AddExtraNodeset
    new_boundary = 'pinned_node'
    nodes = '0'
  [../]
[]

[Variables]
  [./vel_x]
    # order = SECOND
    # family = LAGRANGE
  [../]

  [./vel_y]
    # order = SECOND
    # family = LAGRANGE
  [../]


  [./p]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  # mass
  [./mass]
    type = INSMass
    variable = p
    u = vel_x
    v = vel_y
  [../]

# # x-momentum, time
  # [./x_momentum_time]
  #   type = INSMomentumTimeDerivative
  #   variable = vel_x
  # [../]

  # x-momentum, space
  [./x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_x
    component = 0
  [../]

  # # y-momentum, time
  # [./y_momentum_time]
  #   type = INSMomentumTimeDerivative
  #   variable = vel_y
  # [../]

  # y-momentum, space
  [./y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_y
    component = 1
  [../]
[]

[BCs]
  [./x_no_slip]
    type = DirichletBC
    variable = vel_x
    boundary = 'bottom right left'
    value = 0.0
  [../]

  [./lid]
    type = FunctionDirichletBC
    variable = vel_x
    boundary = 'top'
    function = 'lid_function'
  [../]

  [./y_no_slip]
    type = DirichletBC
    variable = vel_y
    boundary = 'bottom right top left'
    value = 0.0
  [../]

  [./pressure_pin]
    type = DirichletBC
    variable = p
    boundary = 'pinned_node'
    value = 0
  [../]
[]

[Materials]
  [./const]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'rho mu'
    prop_values = '1  1'
  [../]
[]

[Functions]
  [./lid_function]
    # We pick a function that is exactly represented in the velocity
    # space so that the Dirichlet conditions are the same regardless
    # of the mesh spacing.
    type = ParsedFunction
    value = '4*x*(1-x)'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    # solve_type = 'PJFNK'
  [../]
[]

[Executioner]
  type = Steady
  # Run for 100+ timesteps to reach steady state.
  # num_steps = 5
  # dt = .5
  # dtmin = .5
  petsc_options = '-snes_converged_reason -ksp_converged_reason'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  # petsc_options_iname = '-pc_type' # -pc_factor_levels'
  # petsc_options_value = 'ilu' # 2'
  # petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -sub_pc_factor_levels'
  # petsc_options_value = 'asm      2               ilu          4'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-13
  nl_max_its = 6
  l_tol = 1e-6
  l_max_its = 500
[]

[Outputs]
  print_linear_residuals = false
  file_base = lid_driven_out_pspg
  exodus = true
[]
