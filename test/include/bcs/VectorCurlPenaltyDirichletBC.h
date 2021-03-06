//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef VECTORCURLPENALTYDIRICHLETBC_H
#define VECTORCURLPENALTYDIRICHLETBC_H

#include "VectorIntegratedBC.h"

class VectorCurlPenaltyDirichletBC;

template <>
InputParameters validParams<VectorCurlPenaltyDirichletBC>();

class VectorCurlPenaltyDirichletBC : public VectorIntegratedBC
{
public:
  VectorCurlPenaltyDirichletBC(const InputParameters & parameters);

protected:
  Real _penalty;
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  Function & _exact_x;
  Function & _exact_y;
  Function & _exact_z;
};

#endif // VECTORCURLPENALTYDIRICHLETBC_H
