require "#{Rails.root}/lib/rdf_vocabularies/data"
class GenericDataDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.last_job(in: DataVocabulary)
    map.mean(in: DataVocabulary)
    map.hi(in: DataVocabulary)
    map.lo(in: DataVocabulary)
    map.data_columns(in: DataVocabulary)
    map.samples(in: DataVocabulary)
    map.sample_freq(in: DataVocabulary)
    map.setup_params(in: DataVocabulary)
  end
end
