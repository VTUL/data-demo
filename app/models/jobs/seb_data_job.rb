class SebDataJob < ActiveFedoraPidBasedJob
  def queue_name
    :data
  end

  def run
    #TODO: Real processing.
    generic_file.setup_params = []
    generic_file.sample_freq = "2560 MHz"

    generic_file.last_job = self.class
    generic_file.save!
    self.resume()
  end

  def resume()
    #TODO: Next Job
  end
end
