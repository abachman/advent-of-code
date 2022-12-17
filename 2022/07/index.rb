infile = <<EOS
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
EOS

infile = File.open('input.txt').read

# dir:  [size, name, parent, [children]]
# file: [size, name, parent]
root = [0, '/', nil, []]
sys = [-1, nil, nil, [root]]
pwd = sys

def apply_up(dir, size)
  dir[0] += size 
  apply_up(dir[2], size) if dir[2]
end

infile.lines.each do |c|
  ls = false
  case c
  when /^\$ cd (.+)/
    if $1 == '..'
      pwd = pwd[2] # up
    else
      pwd = pwd[3].find {|dir| dir[1] == $1}
    end
  when /dir (.+)/
    pwd[3] << [0, $1, pwd, []]
  when /(\d+) (.+)/
    apply_up(pwd, $1.to_i)
    pwd[3] << [$1.to_i, $2, pwd]
  end
end

def walk(tree, depth = 0, dirs = [])
  prefix = ' ' * (depth + 1)
  tree[3].each do |obj|
    puts prefix + obj[1]
    if obj.size == 4
      dirs << obj[0]
      walk(obj, depth + 1, dirs) 
    end
  end
end

dirs = []
walk sys, 0, dirs

# part 1
unders = dirs.filter {|s| s < 100_000}

puts unders.inspect
puts "PART 1 #{unders.sum}"
puts "---"

# part 2
avail = 70_000_000
req = 30_000_000
have = root[0]
free = avail - have
need = req - free
puts "CUR #{have}"
puts "NED #{need}"

will = dirs.filter {|s| s > need}
puts "WILL #{will.inspect}"
