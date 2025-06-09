// lib/services/slm_model_service.dart
class SLMModelService {
  static final Map<String, ModelInfo> _phoneModelMap = {
    'Samsung Galaxy S24': ModelInfo(
        'MaziyarPanahi/Qwen3-4B-GGUF',
        'Qwen3-4B.Q4_K_M.gguf',
        'Qwen3 4B - Optimized for flagship performance'),
    'Samsung Galaxy S24 Ultra': ModelInfo('MaziyarPanahi/Qwen3-0.6B-GGUF',
        'Qwen3-0.6B.Q6_K.gguf', 'Qwen3 0.6B - Ultra-fast inference'),
    'Samsung Galaxy S25 Ultra': ModelInfo(
        'MaziyarPanahi/Phi-3.5-mini-instruct-GGUF',
        'Phi-3.5-mini-instruct.Q4_K_M.gguf',
        'Phi-3.5 Mini - Latest generation efficiency'),
    'Google Pixel 9 Pro': ModelInfo(
        'MaziyarPanahi/Llama-3.2-3B-Instruct-GGUF',
        'Llama-3.2-3B-Instruct.Q8_0.gguf',
        'Llama 3.2 3B - High-quality instruction following'),
    'Google Pixel 8 Pro': ModelInfo(
        'MaziyarPanahi/Llama-3.2-1B-Instruct-GGUF',
        'Llama-3.2-1B-Instruct.Q6_K.gguf',
        'Llama 3.2 1B - Balanced performance'),
    'Samsung Galaxy Z Fold 6': ModelInfo(
        'mradermacher/Dolphin3-Llama3.2-Smart-GGUF',
        'Dolphin3-Llama3.2-Smart.Q8_0.gguf',
        'Dolphin3 Llama3.2 - Smart reasoning capabilities'),
    'Google Pixel 9': ModelInfo(
        'hugging-quants/Llama-3.2-1B-Instruct-Q8_0-GGUF',
        'llama-3.2-1b-instruct-q8_0.gguf',
        'Llama 3.2 1B - Optimized quantization'),
    'Samsung Galaxy Z Flip 6': ModelInfo(
        'hugging-quants/Llama-3.2-1B-Instruct-Q8_0-GGUF',
        'llama-3.2-1b-instruct-q8_0.gguf',
        'Llama 3.2 1B - Compact form factor optimized'),
    'Google Pixel 8a': ModelInfo('bartowski/gemma-2-2b-it-GGUF',
        'gemma-2-2b-it-Q6_K.gguf', 'Gemma 2 2B - Google\'s efficient model'),
    'Motorola Razr 50 Ultra': ModelInfo(
        'lmstudio-community/DeepSeek-R1-Distill-Qwen-7B-GGUF',
        'DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf',
        'DeepSeek R1 Distilled - Advanced reasoning'),
    'Motorola Edge 50 Pro': ModelInfo(
        'unsloth/Phi-4-mini-instruct-GGUF',
        'Phi-4-mini-instruct-Q4_K_M.gguf',
        'Phi-4 Mini - Latest Microsoft model'),
    'Motorola Edge 50': ModelInfo(
        'lmstudio-community/gemma-3-1B-it-qat-GGUF',
        'gemma-3-1B-it-QAT-Q4_0.gguf',
        'Gemma 3 1B - Quantization-aware training'),
    'Xiaomi 13 Pro': ModelInfo(
        'bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF',
        'DeepSeek-R1-Distill-Qwen-7B-IQ2_M.gguf',
        'DeepSeek R1 - High-end performance'),
    'OnePlus 12': ModelInfo(
        'allenai/OLMoE-1B-7B-0924-Instruct-GGUF',
        'olmoe-1b-7b-0924-instruct-q4_k_m.gguf',
        'OLMoE - Mixture of experts architecture'),
    'Xiaomi 14 Ultra': ModelInfo(
        'bartowski/Llama-3.2-3B-Instruct-GGUF',
        'Llama-3.2-3B-Instruct-Q6_K.gguf',
        'Llama 3.2 3B - Premium performance'),
    'OnePlus Open': ModelInfo('bartowski/SmolLM2-135M-Instruct-GGUF',
        'SmolLM2-135M-Instruct-Q4_0.gguf', 'SmolLM2 135M - Ultra-lightweight'),
    'Sony Xperia 5V': ModelInfo('MaziyarPanahi/Phi-3.5-mini-instruct-GGUF',
        'Phi-3.5-mini-instruct.Q4_K_M.gguf', 'Phi-3.5 Mini - Sony optimized'),
    'Huawei Mate 60 Pro': ModelInfo(
        'NikolayKozloff/DeepSeek-R1-ReDistill-Qwen-1.5B-v1.1-Q8_0-GGUF',
        'deepseek-r1-redistill-qwen-1.5b-v1.1-q8_0.gguf',
        'DeepSeek R1 ReDistilled - Huawei optimized'),
    'Samsung Galaxy A54 5G': ModelInfo(
        'bartowski/Dolphin3.0-Llama3.2-3B-GGUF',
        'Dolphin3.0-Llama3.2-3B-Q4_K_M.gguf',
        'Dolphin 3.0 - Mid-range optimized'),
    'Samsung Galaxy A15': ModelInfo(
        'MaziyarPanahi/Phi-3.5-mini-instruct-GGUF',
        'Phi-3.5-mini-instruct.Q4_K_M.gguf',
        'Phi-3.5 Mini - Entry-level optimized'),
  };

  static ModelInfo? getModelForPhone(String phoneModel) {
    return _phoneModelMap[phoneModel];
  }

  static ModelInfo getDefaultModel() {
    return ModelInfo(
        'bartowski/SmolLM2-135M-Instruct-GGUF',
        'SmolLM2-135M-Instruct-Q4_0.gguf',
        'SmolLM2 135M - Universal compatibility');
  }

  static List<String> getSupportedPhones() {
    return _phoneModelMap.keys.toList();
  }
}

class ModelInfo {
  final String repository;
  final String filename;
  final String description;

  ModelInfo(this.repository, this.filename, this.description);

  String get downloadUrl =>
      'https://huggingface.co/$repository/resolve/main/$filename';
  String get modelName => repository.split('/').last;
}
