#!/usr/bin/ruby
=begin
	element selector base class
	author: Flint LIU
	email: flintliu@hotmail.com
=end

require "flint/object_modules/sample_objects"

module Flint
	class ElementSelector
		def initialize(element_name, elements_info, window)
			@element_name = ele_name
			@elements_info = elements_info
			@window = window
			@path_flow = Array.new()
		end

		def get_ele_info(element_name)
			_element_info = @elements_info[element_name]
			_root_element = _element_info[0]
			_selection_method = _element_info[1]
			_selection_arg = _element_info[2]
			_element_type = _element_info[3]
			return _root_element, _selection_method, _selection_arg, _element_type
		end

		def element_selector(driver)
			if @path_flow.size == 1
				return driver
			else
				@path_flow.pop
				_selection_method = self.get_ele_info(@path_flow[-1])[1]
				_selection_arg = self.get_ele_info(@path_flow[-1])[2]
				if _selection_method == "id"
					driver = driver.find_element(:id, _selection_arg)
