module Validation
  class Uniqueness(T)
    @hash : Hash(String, Granite::Fields::Type)
    @value : Granite::Fields::Type

    def initialize(@model : T, @attribute : String, @whitelist : Array(String))
      @hash = @model.to_h
      @value = @hash[@attribute]
    end

    def valid?
      return true if @whitelist.includes?(@value)
      query.empty?
    end

    private def query
      if @hash["id"]
        T.all("WHERE #{@attribute} = ? AND id != ?", [@value, @hash["id"]])
      else
        T.all("WHERE #{@attribute} = ?", [@value])
      end
    end
  end
end
