# Define OpenAI configuration
OPENAI_CONFIG = {
  prompt: File.read(Rails.root.join('config', 'openai_prompt.txt')),
  inspirations_subprompt: File.read(Rails.root.join('config', 'openai_inspirations_subprompt.txt')),
  model: 'gpt-3.5-turbo',
  temperature: 0.7
}.freeze
