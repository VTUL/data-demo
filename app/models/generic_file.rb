class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include Hydra::Collections::Collectible

  has_metadata 'genericData', type: GenericDataDatastream
  has_attributes :last_job, :data_columns, :samples, :sample_freq, datastream: 'genericData', multiple: false
  has_attributes :setup_params, :mean, :hi, :lo, datastream: 'genericData', multiple: true

  def data?
    # TODO: Move this array to lib/sufia/models/generic_file/mime_types.rb, like in sufia-models.
    # Then call as self.class.data_mime_types
    ['text/csv', 'text/tab-separated-values', 'text/plain'].include?(self.mime_type)
  end

  # Extract the metadata from the content datastream and record it in the characterization datastream
  def characterize
    self.characterization.ng_xml = self.content.extract_metadata
    fix_data_characterization!
    self.append_metadata
    self.filename = self.label
    save
  end

  # The present version of fits doesn't set the official mime-type for CSV files.
  # This method rectifies that until a fixed version of fits is released.
  def fix_data_characterization!
    self.characterization.mime_type = 'text/csv' if mime_type == 'text/plain' && format_label.include?('Comma Separated Values')
    self.characterization.mime_type = 'text/tab-separated-values' if mime_type == 'text/plain' && format_label.include?('Tab-separated values')
  end

  def terms_for_display
    super + [:mean, :hi, :lo, :data_columns, :samples, :sample_freq, :setup_params]
  end
end
