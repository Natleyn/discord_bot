require 'discordrb'
# Add plugin here
require './plugins/roll'

# Test function here
parse_input = "1d20+2d8d1-4+3d4D2x7"
parse_output = SurfBot::Plugins::Roll.parse_roll(parse_input).to_s
expected_parse_output = '[[["1", "20"], ["2", "8", "1"], "4", ["3", "4", "2"]], [["d"], ["d", "d"], [], ["d", "D"]], ["+", "+", "-", "+"], "7"]'
puts "Test #1.1: parse_roll: correct roll string parsing"
puts "Input is:         #{parse_input}"
puts "Output is:        #{parse_output}"
puts "Output should be: #{expected_parse_output}"
puts "Outputs match: #{parse_output == expected_parse_output}\n\n"

# Test function here
parse_input = "1d20+15"
parse_output = SurfBot::Plugins::Roll.parse_roll(parse_input).to_s
expected_parse_output = '[[["1", "20"], "15"], [["d"], []], ["+", "+"], "1"]'
puts "Test #1.2: parse_roll: correct roll string parsing"
puts "Input is:         #{parse_input}"
puts "Output is:        #{parse_output}"
puts "Output should be: #{expected_parse_output}"
puts "Outputs match: #{parse_output == expected_parse_output}\n\n"

# Test function here
stringify_input = [ [[15], [6,2], 4, [4,3,1]], ["+","+","-","+"] ]
stringify_output = SurfBot::Plugins::Roll.stringify_roll(stringify_input[0], stringify_input[1]).to_s
expected_stringify_output = '[15] + [6+2] - 4 + [4+3+1]'
puts "Test #2: stringify_roll: correct stringify of roll results"
puts "Input is:         #{stringify_input}"
puts "Output is:        #{stringify_output}"
puts "Output should be: #{expected_stringify_output}"
puts "Outputs match: #{stringify_output == expected_stringify_output}\n\n"

# Test function here
calculate_input = [ [["1", "20"], ["2", "8", "1"],4,["3","4","2"]], [["d"],["d","d"],[],["d","D"]] , ["+","+","-","+"], false]
calculate_output = SurfBot::Plugins::Roll.calculate_roll(calculate_input[0], calculate_input[1], calculate_input[2], calculate_input[3]).to_s
expected_calculate_output = '[[rolls], rolls sum, [dropped rolls], dropped sum, constant number sum]'
puts "Test #3.1: calculate_roll: rolls dice correctly and removes lowest or highest from proper roll; calculates sums correctly"
puts "Input is:            #{calculate_input}"
puts "Output is:           #{calculate_output}"
puts "Output should match: #{expected_calculate_output}"
puts "Outputs match: #{calculate_output.to_s.match?(/.*/)} test not implemented\n\n"

# Test function here
calculate_input = [ [["1", "20"], ["2", "8", "1"],4,["3","4","2"]], [["d"],["d","d"],[],["d","D"]] , ["+","-","-","-"], false]
calculate_output = SurfBot::Plugins::Roll.calculate_roll(calculate_input[0], calculate_input[1], calculate_input[2], calculate_input[3]).to_s
expected_calculate_output = '[[rolls], rolls sum, [dropped rolls], dropped sum, constant number sum]'
puts "Test #3.2: calculate_roll: rolls dice correctly and removes lowest or highest from proper roll; calculates sums correctly"
puts "Input is:            #{calculate_input}"
puts "Output is:           #{calculate_output}"
puts "Output should match: #{expected_calculate_output}"
puts "Outputs match: #{calculate_output.to_s.match?(/.*/)} test not implemented\n\n"

# Test function here
form_input = [ "1d20+2d8d1-4+3d4D2", [ [[15],[6,2],4,[4,3,1]], 27, [[15],[6],4,[1]], 18], ["+","+","-","+"], false, -4 ] 
form_output = SurfBot::Plugins::Roll.form_result(form_input[0], form_input[1], form_input[2], form_input[3], form_input[4]).to_s
expected_form_output = '1d20+2d8d1-4+3d4D2 = [15] + [6+2] - 4 + [4+3+1] => [15] + [6] - 4 + [1] = **18**'
puts "Test #4: form_result: Formats output of final string correctly"
puts "Input is:         #{form_input}"
puts "Output is:        #{form_output}"
puts "Output should be: #{expected_form_output}"
puts "Outputs match: #{form_output == expected_form_output}\n\n"

# Test function here
form_input = [ "1d20+2d8-4+3d4", [ [[15],[6,2],4,[4,3,1]], 35, [[15],[6,2],4,[4,3,1]], 35], ["+","+","-","+"], false, -4] 
form_output = SurfBot::Plugins::Roll.form_result(form_input[0], form_input[1], form_input[2], form_input[3], form_input[4]).to_s
expected_form_output = '1d20+2d8-4+3d4 = [15] + [6+2] - 4 + [4+3+1] = **35**'
puts "Test #5: form_result: Formats output of final string correctly"
puts "Input is:         #{form_input}"
puts "Output is:        #{form_output}"
puts "Output should be: #{expected_form_output}"
puts "Outputs match: #{form_output == expected_form_output}\n\n"

# Test function here
form_input = [ "11d2+2", [ [[1,1,2,2,1,1,2,2,1,2,1],2], 18, [[1,1,2,2,1,1,2,2,1,2,1],2], 18, 2, 12], ["+","+"], false, 12] 
form_output = SurfBot::Plugins::Roll.form_result(form_input[0], form_input[1], form_input[2], form_input[3], form_input[4]).to_s
expected_form_output = '11d2+2 = [16] + 2 = **18**'
puts "Test #5: form_result: Formats output of final string correctly"
puts "Input is:         #{form_input}"
puts "Output is:        #{form_output}"
puts "Output should be: #{expected_form_output}"
puts "Outputs match: #{form_output == expected_form_output}\n\n"

# Test function here
form_input = [ "11d2+2", [ [[1,1,2,2,1,1,2,2,1,2,1],2], 18, [[1,1,2,2,1,1,2,2,1,2,1],2], 18, 2, 12], ["+","+"], true, 12] 
form_output = SurfBot::Plugins::Roll.form_result(form_input[0], form_input[1], form_input[2], form_input[3], form_input[4]).to_s
expected_form_output = '11d2+2 = [1+1+2+2+1+1+2+2+1+2+1] + 2 = **18**'
puts "Test #5: form_result: Formats output of final string correctly"
puts "Input is:         #{form_input}"
puts "Output is:        #{form_output}"
puts "Output should be: #{expected_form_output}"
puts "Outputs match: #{form_output == expected_form_output}\n\n"
