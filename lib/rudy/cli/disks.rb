

module Rudy
  module CLI
    class Disks < Rudy::CLI::CommandBase

      
      def disks
        rdisk = Rudy::Disks.new
        rback = Rudy::Backups.new
        more, less = [], []
        less = [:environment, :role] if @option.all
        # We first get the disk metadata
        disk_list = rdisk.list(more, less) || []
        # If there are no disks currently, there could be backups
        # so we grab those to create a list of disks. 
        if @option.backups
          backups = rback.list(more, less) || []
          backups.each_with_index do |b, index|
            disk_list << b.disk
          end
        end
        # We go through the list of disks but we'll skip ones we've seen
        seen = []
        disk_list.each do |d|
          next if seen.member?(d.name)
          seen << d.name
          puts @@global.verbose > 0 ? d.inspect : d.dump(@@global.format)
          if @option.backups
            d.list_backups.each_with_index do |b, index|
              puts '  %s' % b.name
              break if @option.all.nil? && index >= 2 # display only 3, unless all
            end
          end
        end
      end
      
      def disks_wash
        rdisk = Rudy::Disks.new
        dirt = (rdisk.list || [])#.select { |d| d.available? }
        if dirt.empty?
          puts "Nothing to wash in #{rdisk.current_machine_group}"
          return
        end
        
        puts "The following disk metadata will be deleted:"
        puts dirt.collect {|d| d.name }
        execute_check(:medium)

        dirt.each do |d|
          d.destroy(:force)
        end
        
      end
      
    end
  end
end