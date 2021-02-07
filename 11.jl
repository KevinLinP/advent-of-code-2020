import Printf.@printf

struct InputSpec
  path
  width
  height
end

struct CoordWithVis
  coord::CartesianIndex
  visiblecoords::Vector{CartesianIndex}
end

function parseinput(inputpath, offset)
  coords = Vector{CartesianIndex}()

  for (y, line) in enumerate(eachline(inputpath))
    for (x, char) in enumerate(line)
      if char == 'L'
        push!(coords, CartesianIndex(y+offset, x+offset))
      end
    end
  end

  return coords
end

function calcdirections()
  directions = collect(Base.product(-1:1, -1:1))
  directions = [(directions)...]
  directions = filter(x -> (x[1] != 0 || x[2] != 0), directions)

  # @show directions

  return directions
end

function calculate_coords_with_visible_coords(inputspec)
  coords = parseinput(inputspec.path, 0)
  grid = falses(inputspec.height, inputspec.width)
  directions = calcdirections()

  for coord in coords
    grid[coord] = true
  end

  coords_with_vis = Vector{CoordWithVis}()

  for coord in coords
    visiblecoords = Vector{CartesianIndex}()

    for direction in directions
      x = coord[2] + direction[1]
      y = coord[1] + direction[2]

      while (x >= 1) && (x <= inputspec.width) && (y >= 1) && (y <= inputspec.height)
        if grid[y, x]
          push!(visiblecoords, CartesianIndex(y, x))
          break
        else
          x += direction[1]
          y += direction[2]
        end
      end
    end

    push!(coords_with_vis, CoordWithVis(coord, visiblecoords))
  end

  # @show coords_with_vis

  return coords_with_vis
end


function solvevisible(inputspec)
  currentgrid = falses(inputspec.height, inputspec.width)
  nextgrid = falses(inputspec.height, inputspec.width)

  allcoordwithvis = calculate_coords_with_visible_coords(inputspec)

  anychanged = true
  iterationcount = 0
  while anychanged
    anychanged = false
    iterationcount += 1

    for coordwithvis in allcoordwithvis
      coord = coordwithvis.coord
      visiblecoords = coordwithvis.visiblecoords

      isoccupied = currentgrid[coord]

      if isoccupied
        if length(visiblecoords) < 5
          continue
        end

        occupiedcount = 0

        for visiblecoord in visiblecoords
          if currentgrid[visiblecoord]
            occupiedcount += 1
          end

          if occupiedcount >= 5
            nextgrid[coord] = false
            anychanged = true
            continue
          end
        end
      else
        # i find the .any more explict to read than the .all
        if any(visiblecoord -> (currentgrid[visiblecoord]), visiblecoords)
          continue
        else
          nextgrid[coord] = true
          anychanged = true
        end
      end
    end

    copyto!(currentgrid, nextgrid)
  end

  @printf("iterationcount: %i, filledseats: %i\r\n", iterationcount, count(b->(b), currentgrid))
end

# i'm oversizing the array by +2 in each direction
# to avoid doing conditional checks
function solveneighbor(inputspec)
  xsize = inputspec.width + 2 # Julia arrays start at 1
  ysize = inputspec.height + 2

  currentgrid = falses(ysize, xsize)
  nextgrid = falses(ysize, xsize)
  coords = parseinput(inputspec.path, 1)

  anychanged = true
  iterationcount = 0
  while anychanged
    anychanged = false
    iterationcount += 1

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

  @printf("iterationcount: %i, filledseats: %i\r\n", iterationcount, count(b->(b), nextgrid))
end

function printgrid(grid)
  # TODO: make better
  @show grid
end

function solve()
  # inputspec = InputSpec("11.input.sample", 10, 10)
  inputspec = InputSpec("11.input", 92, 94)

  # @time begin
    # println("neighbor:")
    # solveneighbor(inputspec)
  # end
  # println("")

  @time begin
    println("visible:")
    solvevisible(inputspec)
  end
end

solve()

