task :environment do |_, _args|
  require_relative 'lib/hackattic'
end

desc 'solves a challenge'
task :solve, %i[challenge] => :environment do |_, args|
  if args[:challenge]
    Hackattic.solve(args[:challenge])
  end
end
