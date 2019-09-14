# SPDX-License-Identifier: MIT
module Entity3D
  class Static
    include BlueKitty::Entity3D

    def initialize(model, position, rotation)
      @model = model
      @position = position
      @rotation = rotation
    end
  end
end
