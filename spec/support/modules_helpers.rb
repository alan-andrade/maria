def extend_class_with m
  Class.new do
    extend m
  end
end

def class_module_include m
  Class.new do
    include m
  end
end
