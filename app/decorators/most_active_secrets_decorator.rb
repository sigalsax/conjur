# Prepares most_active_secrets data for the bar chart display
#
class MostActiveSecretsDecorator

  attr_reader :entries, :label_width, :max_bar_width

  # data type: [{label: 'ci/jenkins', value: 25}, ...]
  #
  def initialize(data, label_width: 0.4)
    @label_width   = label_width
    @max_bar_width = 1.0 - label_width
    @entries       = sort_desc(add_normalized_values(max_bar_width, data))
  end

  private

  # linearly rescales all array values so maximum value is max
  # adds these normalized values as the :width prop
  def add_normalized_values(max, data)
    cur_max = data.map {|x| x[:value]}.max.to_f
    data.map {|x| x.merge(width: x[:value] * max / cur_max)}
  end

  def sort_desc(data)
    data.sort_by {|x| x[:value]}.reverse
  end

end
