function run()
  numvalidpassports = 0

  currentfieldcount = 0
  for line in eachline("4.input")
    if line != ""
      tokens = split(line, " ", keepempty = false)

      for token in tokens
        if !startswith(token, "cid")
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
