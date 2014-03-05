class DataPreviewJob < ActiveFedoraPidBasedJob
  def queue_name
    :data
  end

  def run
    colsize = nil
    samples = 0
    hi = []
    lo = []
    mean = []
    generic_file.content.content.each_line do |line|
      columns = line.split("\t")
      # Init colsize if multiple columns are found, else skip.
      colsize = columns.size if colsize.nil? and columns.size > 1
      if columns.size == colsize and /\d+\.\d+/.match(line)
        columns.zip(hi, lo, mean).each_with_index do |terms, index|
          # terms = {0: columns[n], 1: hi[n], 2: lo[n], 3: mean[n]}
          terms[0] = terms[0].to_f
          hi[index] = terms[0] if terms[1].nil? or terms[0] > terms[1]
          lo[index] = terms[0] if terms[2].nil? or terms[0] < terms[2]
          terms[3] = 0 if terms[3].nil?
          mean[index] = (terms[3] * samples + terms[0]) / (samples + 1)
        end
        samples += 1
      else
        # Number of columns changed. Error?
      end
    end

    #generic_file.line_count.append(count)
    generic_file.hi = hi
    generic_file.lo = lo
    generic_file.mean = mean
    generic_file.data_columns = colsize
    generic_file.samples = samples

    generic_file.last_job = self.class
    generic_file.save!
    self.resume()
  end

  def resume()
    if generic_file.collections.include? 'SEB Data'
      Sufia.queue.push(SebDataJob.new(generic_file_id))
    end
  end
end
