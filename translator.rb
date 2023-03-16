regex = {
  comment: /^(\/\/.*$|\/\*[\s\S]*?\*\/)/,
  delimiter: /^[\s\t\n\r\f\v\[\]\(\)\{\},\.;:]/,
  operator: /^([-*+%=><!&|]{1,2})/,
  number: /^([+-]?\d+(\.\d+)?([eE][+-]?\d+)?)/,
  keyword: /^(break|clone|continue|declare|die|do|echo|else|elseif|empty|enddeclare|
endfor|endforeach|endif|endswitch|endwhile|eval|exit|for|foreach|function|global|goto|
if|include|include_once|isset|list|namespace|new|print|require|require_once|return|
static|switch|throw|trait|try|unset|use|var|while|xor)\b/m,
  identifier: /^(\$[a-zA-Z_][a-zA-Z0-9_]*[(]?)|(?<=^)(\w+(?=\())/,          #(\b(?!function\b)\w+(?=\())(?<!._\d)
  string: /^('[^'\\]*(?:\\.[^'\\]*)*'|"[^"\\]*(?:\\.[^"\\]*)*")/,
}

token_table = {
  operator: {},
  identifier: {},
  keyword: {},
  number: {},
  string: {},
  comment: {},
  delimiter: {}
}

php_code = File.readlines('code.txt')

text = php_code
analysed_text = ''

text.each_with_index do |line, index|
  until line.eql?('')
    regex.each { |key, value|
      current_token = line.match(value)
      if current_token
        token = current_token.to_s
        if token_table[key][token]
          # Token already exists, use existing identifier
          identifier = token_table[key][token]
        else
          # Token is new, create new identifier
          identifier = "#{key.to_s[0].upcase}_#{token_table[key].size + 1}"
          token_table[key][token] = identifier
        end
        line.sub!(token, '')
        analysed_text += identifier
      end
    }
  end
end

token_table.each do |key, value|
  puts key, value
end

puts "\n", analysed_text


token_table.each do |key, value|
  value.each do |token, identifier|
    analysed_text.gsub!(identifier, token)
  end
end

puts "\n", analysed_text

