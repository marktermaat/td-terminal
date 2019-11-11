#!/usr/bin/env ruby

module Td
  require_relative 'td/cli'

  def self.start()
    Td::Cli.start
  end
end

Td.start()