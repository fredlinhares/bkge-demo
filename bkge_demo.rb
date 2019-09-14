# SPDX-License-Identifier: MIT
require 'blue_kitty'

require_relative 'entity3d/static'
require_relative 'stage/main'

BlueKitty::Engine.run({}, 'config.yml') do |global_data|
  Stage::Main.new(global_data)
end
