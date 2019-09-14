# SPDX-License-Identifier: MIT
module Stage
  class Main
    def initialize(global_data)
      @model1 = BlueKitty::Model.new("assets/meshes/cube.bkm")
      @model2 = BlueKitty::Model.new("assets/meshes/tetrahedron.bkm")

      @moving = false
      @rotating = false
      @movement = BlueKitty::Vector3D.new(0.0, 0.0, 0.0)
      @translated_movement = BlueKitty::Vector3D.new(0.0, 0.0, 0.0)

      @camera_pos = BlueKitty::Vector3D.new(0.0, 0.0, 0.0)
      @camera_rotation = BlueKitty::Vector3D.new(0.0, 0.0, 0.0)

      entity1_pos = BlueKitty::Vector3D.new(3.0, 0.0, 0.0)
      entity1_rotation = BlueKitty::Vector3D.new(0.0, 0.0, 0.0)

      entity2_pos = BlueKitty::Vector3D.new(-3.0, 0.0, 0.0)
      entity2_rotation = BlueKitty::Vector3D.new(0.0, 0.0, 0.0)

      entity3_pos = BlueKitty::Vector3D.new(0.0, 0.0, 3.0)
      entity3_rotation = BlueKitty::Vector3D.new(0.0, 0.0, 0.0)

      entity4_pos = BlueKitty::Vector3D.new(0.0, 0.0, -3.0)
      entity4_rotation = BlueKitty::Vector3D.new(0.0, 0.0, 0.0)

      @current_camera = BlueKitty::Camera.new(@camera_pos, @camera_rotation)
      @entities3d = [
        Entity3D::Static.new(@model1, entity1_pos, entity1_rotation),
        Entity3D::Static.new(@model1, entity2_pos, entity2_rotation),
        Entity3D::Static.new(@model2, entity3_pos, entity3_rotation),
        Entity3D::Static.new(@model2, entity4_pos, entity4_rotation)]

      @controller = BlueKitty::Controller.new

      @controller.add_command(:turn_left) do
        @rotating = true
        @rotation = 0.5
      end
      @controller.add_command(:turn_right) do
        @rotating = true
        @rotation = -0.5
      end
      @controller.add_command(:stop_left) do
        @rotating = false
      end
      @controller.add_command(:stop_right) do
        @rotating = false
      end

      @controller.add_command(:move_forward) do
        @moving = true
        @movement.z = -1.0
      end
      @controller.add_command(:move_backward) do
        @moving = true
        @movement.z = 1.0
      end
      @controller.add_command(:stop_forward) do
        @moving = false
      end
      @controller.add_command(:stop_backward) do
        @moving = false
      end
      @controller.add_command(:quit_game) do
        BlueKitty::Engine::quit_game
      end

      @input_device = BlueKitty::InputDevice.new

      @input_device.add_keydown(BlueKitty::Keycode::W, :move_forward)
      @input_device.add_keydown(BlueKitty::Keycode::S, :move_backward)
      @input_device.add_keyup(BlueKitty::Keycode::W, :stop_forward)
      @input_device.add_keyup(BlueKitty::Keycode::S, :stop_backward)

      @input_device.add_keydown(BlueKitty::Keycode::A, :turn_left)
      @input_device.add_keydown(BlueKitty::Keycode::D, :turn_right)
      @input_device.add_keyup(BlueKitty::Keycode::A, :stop_left)
      @input_device.add_keyup(BlueKitty::Keycode::D, :stop_right)
    end

    def tick(delta)
      if @rotating then
        @camera_rotation.update_y(@rotation)
      end

      if @moving then
        @translated_movement.set_xyz(
          @movement.x * delta, @movement.y * delta, @movement.z * delta)
        @translated_movement.rotate(@current_camera.rotation)
        @current_camera.position.update_xyz(
          @translated_movement.x, @translated_movement.y,
          @translated_movement.z)
      end
    end
  end
end
