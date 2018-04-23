
class String
  def numeric?
    true if Float(self) rescue false
  end

  def begins_with?(test)
    self[0, test.length] == test
  end

  def ends_with?(test)
    self[length - test.length, test.length] == test
  end

  def endline?
    self == "\n"
  end
end

class MorseEncoder
  def initialize
    @morse_code = {
      a: ".-",
      b: "-...",
      c: "-.-.",
      d: "-..",
      e: ".",
      f: "..-.",
      g: "--.",
      h: "....",
      i: "..",
      j: ".---",
      k: "-.-",
      l: ".-..",
      m: "--",
      n: "-.",
      o: "---",
      p: ".--.",
      q: "--.-",
      r: ".-.",
      s: "...",
      t: "-",
      u: "..-",
      v: "...-",
      w: ".--",
      x: "-..-",
      y: "-.--",
      z: "--..",
      _0: "-----",
      _1: ".----",
      _2: "..---",
      _3: "...--",
      _4: "....-",
      _5: ".....",
      _6: "-....",
      _7: "--...",
      _8: "---..",
      _9: "----.",
    }
    @inverted_code = @morse_code.invert
  end

  def encode_file(inputFile, outputFile)
    lines = load_file(inputFile)

    File.open(outputFile, "w") do |file|
      lines.each do |line|
        file.puts encode_text(line)
      end
    end
  end

  def decode_file(encoded_file, outputFile)
    lines = load_file(encoded_file)

    File.open(outputFile, "w") do |file|
      lines.each do |line|
        file.puts decode_text(line)
      end
    end
  end

  def decode_text(encrypted_text)
    proccessed_text = ""
    values = encrypted_text.split(/ /)

    values.each do |code|
      proccessed_text += decode_char(code)
    end
    proccessed_text
  end

  def encode_text(raw_text)
    proccessed_text = ""
    raw_text.each_char do |charmander|
      charmander.downcase!
      proccessed_text += encode_char(charmander)
    end
    proccessed_text
  end

  private

  def load_file(inputFile)
    lines = []
    File.open(inputFile, "r") do |file|
      file.each do |line|
        lines.push (line)
      end
    end

    lines
  end

  def decode_char(code)
    if (code.empty?)
      decoded_code = " "
    else
      decoded_code = @inverted_code[code].to_s.upcase
      if (decoded_code.begins_with? "_")
        decoded_code = decoded_code[1, 1]
      end
    end
    decoded_code
  end

  def encode_char(charmander)
    if (charmander.numeric?)
      char = "_#{charmander}"
      char = "#{@morse_code[char.to_sym]} "
    elsif charmander.endline?
      char = charmander
    else
      char = "#{@morse_code[charmander.to_sym]} "
    end
    char
  end
end

encoder = MorseEncoder.new

option = ARGV[0] != nil ? ARGV[0].upcase : nil

if (option == "ENCODE")
  fileName = ARGV[1]
  if (!fileName.ends_with? ".txt")
    fileName += ".txt"
  end
  outputFile = String.new(fileName).insert(fileName.length - ".txt".length, "-encoded")
  encoder.encode_file(fileName, outputFile)
elsif (option == "DECODE")
  fileName = ARGV[1]
  if (!fileName.ends_with? ".txt")
    fileName += ".txt"
  end
  outputFile = String.new(fileName).insert(fileName.length - ".txt".length, "-decoded")
  encoder.decode_file(fileName, outputFile)
end
