# encoding: utf-8
module Watir
  module Container
    def all(*args)
      if args.length == 2
        elements(args[0] => args[1]).to_a.map(&:to_subtype)
      else
        elements(:css => args[0] || '*').to_a.map(&:to_subtype)
      end
    end

    def first(*args)
      element = if args.length == 2
                  element(args[0] => args[1])
                else
                  element(:css => args[0])
                end

      element.exist? ? element.to_subtype : nil
    end

    def find(*args)
      elements = if args.length == 2
                   elements(args[0] => args[1]).to_a.map(&:to_subtype)
                 else
                   elements(:css => args[0]).to_a.map(&:to_subtype)
                 end

      raise Watir::Exception::Ambiguous.new("Ambiguous match, found #{elements.length} elements matching #{args[1] || args[0]}") if elements.length > 1

      elements.empty? ? nil : elements.first.to_subtype
    end

    def find_xpath(selector)
      find(:xpath, selector)
    end

    def find_css(selector)
      find(:css, selector)
    end

    def has_no_selector?(*args)
      first(args).nil?
    end

    alias_method :have_no_selector?, :has_no_selector?

    def has_selector?(*args)
      !has_no_selector?(args)
    end

    alias_method :have_selector?, :has_selector?

    def has_no_xpath?(selector)
      first(:xpath, selector).nil?
    end

    alias_method :have_no_xpath?, :has_no_xpath?

    def has_xpath?(selector)
      !has_no_xpath?(selector)
    end

    alias_method :have_xpath?, :has_xpath?

    def has_no_css?(selector)
      first(:css, selector).nil?
    end

    alias_method :have_no_css?, :has_no_css?

    def has_css?(selector)
      !has_no_css?(selector)
    end

    alias_method :have_css?, :has_css?

    def has_no_content?(text)
      text = text.is_a?(Regexp) ? text : Regexp.new(Regexp.escape(text))
      text.scan(text).empty?
    end

    alias_method :have_no_content?, :has_no_content?

    def has_content?(text)
      !has_no_content?(text)
    end

    alias_method :have_content?, :has_content?

    def fill_in(selector, options = {})
      find(selector).set(options[:with])
    end

    def click_button(selector)
      %w(id text value).each do |field|
        element = button(field.to_sym => selector)
        if element.exist?
          element.click
          return element
        end
      end

      raise_can_not_find_by(selector)
    end

    def click_link(selector)
      %w(id text).each do |field|
        element = link(field.to_sym => selector)
        if element.exist?
          element.click
          return element
        end
      end

      image = image(:alt => selector)
      if image.exist?
        element = image.parent
        if element.exist? && element.is_a?(Watir::Anchor)
          element.click
          return element
        end
      end

      raise_can_not_find_by(selector)
    end

    def choose(selector)
      find_by_name_id_or_label(:radio, selector).set(true)
    end

    def check(selector)
      find_by_name_id_or_label(:checkbox, selector).set(true)
    end

    def uncheck(selector)
      find_by_name_id_or_label(:checkbox, selector).set(false)
    end

    def select(value, options = {})
      if options.has_key?(:from)
        select = find_by_name_id_or_label(:select_list, options[:from])
        select.option(:text => value).select

        select
      else
        option = option(:text => value)
        option.select

        option
      end
    end

    def unselect(value, options={})
      if options.has_key?(:from)
        select = find_by_name_id_or_label(:select_list, options[:from])
        select.option(:text => value).clear
      else
        option(:text => value).clear
      end
    end

    def attach_file(selector, path)
      Array(path).each do |p|
        raise Capybara::FileNotFound, "cannot attach file, #{p} does not exist" unless File.exist?(p.to_s)
      end

      find_by_name_id_or_label(:file_field, selector).set(path)
    end

    private

    def raise_can_not_find_by(selector)
      raise Watir::Exception::UnknownObjectException, "unable to locate element, using `#{selector}`"
    end

    def find_by_name_id_or_label(field_type, selector)
      %w(name id).each do |field|
        element = send(field_type, field.to_sym => selector)
        return element if element.exist?
      end

      label = label(:text => selector)
      raise_can_not_find_by(selector) unless label.exist?

      id = label(:text => selector).for
      element = file_field(:id => id)
      return element if element.exist?

      raise_can_not_find_by(selector)
    end
  end
end
