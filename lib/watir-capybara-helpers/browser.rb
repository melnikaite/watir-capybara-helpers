# encoding: utf-8
module Watir
  class Browser
    extend Forwardable

    alias_method :current_url, :url
    alias_method :visit, :goto
    alias_method :go_back, :back
    alias_method :go_forward, :forward

    def_delegator :@driver, :window_handle, :current_window_handle

    def evaluate_script(script)
      execute_script "return #{script}"
    end

    def save_screenshot(path = nil, options = {})
      path ||= "watir-#{DateTime.now.strftime("%Y%m%d%H%M%S")}#{rand(10**10)}.png"
      screenshot.save path
      path
    end

    def save_page(path = nil)
      path ||= "watir-#{DateTime.now.strftime("%Y%m%d%H%M%S")}#{rand(10**10)}.html"
      File.open(path, 'w') { |f| f.write(browser.html) }
      path
    end

    def save_and_open_page(path = nil)
      require "launchy"
      Launchy.open(save_page(path))
    rescue LoadError
      warn "Please install the launchy gem to open page with save_and_open_page"
    end

    def save_and_open_screenshot(path = nil, options = {})
      require "launchy"
      Launchy.open(save_screenshot(path))
    rescue LoadError
      warn "Please install the launchy gem to open page with save_and_open_page"
    end

    def within(*args, &block)
      element = if args[0].is_a?(Watir::Element)
                  args[0]
                else
                  find(*args)
                end
      element.instance_eval &block
    end

    def within_frame(selector, &block)
      frame = %w(id name).each do |field|
        element = browser.frame(field.to_sym => selector)
        break element if element.exist?
      end

      raise_can_not_find_by(selector) unless frame.class.eql?(Watir::Frame)

      frame.instance_eval &block
    end

    # make all selenium methods accessible
    def method_missing(name, *args, &block)
      if driver.respond_to?(name)
        driver.send(name, *args, &block)
      else
        super
      end
    end
  end
end
