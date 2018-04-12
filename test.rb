
logging = lambda { |x| puts x }

def callback(fn)
  p fn["Hello"]
end

callback(logging)
