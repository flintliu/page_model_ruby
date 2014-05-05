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
				elsif _selection_method == "ids"
					driver = driver.find_elements(:id, _selection_arg)
				elsif _selection_method == "xpath"
					driver = driver.find_element(:xpath, _selection_arg)
				elsif _selection_method == "name"
					driver = driver.find_element(:name, _selection_arg)
				elsif _selection_method == "className"
					driver = driver.find_element(:class_name, _selection_arg)
				elsif _selection_method == "tagName"
					driver = driver.find_element(:tag_name, _selection_arg)
				elsif _selection_method == "linkText"
					driver = driver.find_element(:link_text, _selection_arg)
				elsif _selection_method == "linkPartialText"
					driver = driver.find_element(:link_partial_text, _selection_arg)
				elsif _selection_method == "css"
					driver = driver.find_element(:css, _selection_arg)
				end
				return self.element_selector(driver)
			end

		def path_builder(root_element)
			@path_flow << root_element
			if @path_flow[-1] == "window"
				return nil
			else
				root_element = self.get_ele_info(root_element)[0]
				return self.path_builder(root_element)
			end

		def get_element()
			self.path_builder(@element_name)
			_element = self.element_selector(@window)
			_element_type = self.get_ele_info(@element_name)[3]
			if _element_type != "" and OBJECT_MAP.has_key?(_element_type)
				return OBJECT_MAP[_element_type](_element)
			else
				return _element
			end
		end
	end
end