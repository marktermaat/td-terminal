#!/usr/bin/env ruby

module Td
  require_relative 'td/cli'

  def self.start()
    Td::Cli.new.start()
  end
end

Td.start()