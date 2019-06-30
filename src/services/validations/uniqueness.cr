module Validation
  class Uniqueness(T)
    def initialize(@model : T, @attribute : String)
    end

    def valid?
      query.empty?
    end

    private def query
      hash = @model.to_h
      if hash["id"]
        T.all("WHERE #{@attribute} = ? AND id != ?", [hash[@attribute], hash["id"]])
      else
        T.all("WHERE #{@attribute} = ?", [hash[@attribute]])
      end
    end
  end
end
