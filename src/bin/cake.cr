# This binary allows to execute Rake-like tasks.
# See https://github.com/axvm/cake,
# also see https://github.com/vladfaust/cake-bake.cr
require "cake-bake"
Cake.bake("../../Cakefile")
