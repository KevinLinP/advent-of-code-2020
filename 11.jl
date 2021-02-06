import Printf.@printf

function parseinput(inputpath)
  coords = Vector{CartesianIndex}()

  for (y, line) in enumerate(eachline(inputpath))
    for (x, char) in enumerate(line)
      if char == 'L'
        push!(coords, CartesianIndex(y+1, x+1))
      end
    end
  end

  return coords
end

function printgrid(grid)
  # TODO: make better
  @show grid
end

# i'm oversizing the array by +2 in each direction
# to avoid doing conditional checks inside the loop
function solve()
  # inputspec = ("10.input.sample", 10, 10)
  inputspec = ("11.input", 92, 94)
  xsize = inputspec[2] + 2 # Julia arrays start at 1
  ysize = inputspec[3] + 2

  currentgrid = falses(ysize, xsize)
  nextgrid = falses(ysize, xsize)
  coords = parseinput(inputspec[1])

  anychanged = true

  while anychanged
    anychanged = false

    for coord in coords
      # @show coord
      subarray = view(currentgrid, coord[1]-1:coord[1]+1, coord[2]-1:coord[2]+1)

      currentvalue = subarray[2, 2]
      neighborcount = count(b->(b), subarray) - (currentvalue ? 1 : 0)

      if currentvalue && neighborcount >= 4
        nextgrid[coord] = false
        anychanged = true
      elseif !currentvalue && neighborcount == 0
        nextgrid[coord] = true
        anychanged = true
      # else
        # nextgrid[coord] = currentvalue
      end

      # @show coord, subarray, currentvalue, neighborcount
    end

    # printgrid(nextgrid)

    # bulk copying turns out to execute faster
    copyto!(currentgrid, nextgrid)
    # tempgrid = currentgrid
    # currentgrid = nextgrid
    # nextgrid = tempgrid
  end

  @printf("%i\r\n", count(b->(b), nextgrid))
end

@time begin
  solve()
end
