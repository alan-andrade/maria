module Maria

  class Page
    attr_reader :body, :name

    def save
      self
    end

    def persisted?
      true
    end

  end

end
