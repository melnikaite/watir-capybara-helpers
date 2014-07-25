# encoding: utf-8
module Watir
  class Element
    def prev
      element(:xpath => 'preceding-sibling::*')
    end

    def next
      element(:xpath => 'following-sibling::*')
    end
  end
end
