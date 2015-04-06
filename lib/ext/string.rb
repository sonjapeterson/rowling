class String
  def camelize
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    arr = split('_').map do |e| 
      if e == "api"
        e.upcase
      else
        e.capitalize
      end
    end
    arr.join
  end
end
