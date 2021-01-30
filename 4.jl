# probably my language of choice if speed was a factor,
# but not enough that I wanted Rust

# this actually returns 104, but the correct answer is 103???

global EYE_COLORS = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

function tokenisvalid(token)
  valid = false

  splittoken = split(token, ":")
  fieldname = splittoken[1] # arrays start at 1 =(
  value = splittoken[2]

  if fieldname == "byr"
    num = parse(Int, value)
    valid = (num >= 1920) && (num <= 2002)
  elseif  fieldname == "iyr"
    num = parse(Int, value)
    valid = (num >= 2010) && (num <= 2020)
  elseif fieldname == "eyr"
    num = parse(Int, value)
    valid = (num >= 2020) && (num <= 2030)
  elseif fieldname == "hgt"
    regexmatch = match(r"(\d+)(cm|in)", value)

    if regexmatch != nothing
      captures = regexmatch.captures
      num = parse(Int, captures[1])
      unit = captures[2]

      if unit == "cm"
        valid = (num >= 150) && (num <= 193)
      elseif unit == "in"
        valid = (num >= 59) && (num <= 76)
      end
    end
  elseif fieldname == "hcl"
    valid = occursin(r"#[0-9a-f]{6}", value)
  elseif fieldname == "ecl"
    valid = in(value, EYE_COLORS)
  elseif fieldname == "pid"
    valid = occursin(r"\d{9}", value)
  end

  println(token * " " * (valid ? "valid" : "invalid"))

  return valid
end

function run()
  numvalidpassports = 0

  currentfieldcount = 0
  for line in eachline("4.input")
    if line != ""
      tokens = split(line, " ", keepempty = false)

      for token in tokens
        if tokenisvalid(token)
          currentfieldcount += 1
        end
      end
    else
      if currentfieldcount == 7
        numvalidpassports += 1
      end

      currentfieldcount = 0
    end
  end

  if currentfieldcount == 7
    numvalidpassports += 1
  end

  println(numvalidpassports)
end

run()
