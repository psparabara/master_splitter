module MasterSplitter
  def standard_splitter(source_file_name, number_of_slices, options={})
    slice_sizes = []
    slice_names = []
    output_dir = options[:output_dir] || ""
    source = File.open(source_file_name, 'rb')
    source_size = source.size
    slice_size = source_size / number_of_slices

    number_of_slices.times do |n|
      slice_sizes << slice_size
      temp = ("%3d"%[n + 1]).gsub(" ", "0")
      slice_names << File.join(output_dir, [source_file_name, temp].join('.'))
    end
    remain_bytes = source_size - (slice_size * number_of_slices)
    slices_sizes[-1] +=  remain_bytes

    source.close
    split(source_file_name, slice_names, slice_sizes)
  end

  def split(source_file_name, slice_names, slices_sizes)
    source = File.open(source_file_name, 'rb')

    slice_names.size.times do |i|
      slice = File.open(slice_names[i], 'wb')
      bytes_to_write = slices_sizes[i]

      while bytes_to_write > 0
        chunk = MAX_CHUNK_SIZE
        chunk = bytes_to_write if(bytes_to_write < MAX_CHUNK_SIZE)
        slice.write(source.read(chunk))
        bytes_to_write -= chunk
      end #end of while
      slice.close
    end #end of iteration

    source.close
  end #end of split
end #end of module