# OpenAI configuration
OPENAI_CONFIG = {
  # default
  prompt: File.read(Rails.root.join('config', 'openai', 'openai_prompt.txt')),
  model: 'gpt-3.5-turbo',
  temperature: 0.7,
  # inspirations
  inspirations_subprompt: File.read(Rails.root.join('config', 'openai', 'openai_inspirations_subprompt.txt')),
  inspirations_probability: 2, # 20%
  inspirations_sample_size_min: 2,
  inspirations_sample_size_max: 5
}.freeze
