json.array!(@samples) do |sample|
  json.extract! sample, :id, :title, :description
  json.url sample_url(sample, format: :json)
end
