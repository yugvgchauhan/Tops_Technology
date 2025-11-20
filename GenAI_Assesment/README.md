# Multi-Task NLP Assistant

A comprehensive Natural Language Processing application built with Hugging Face Transformers and Streamlit. This application provides multiple NLP tasks through an intuitive web interface.

## Features

The application supports the following NLP tasks:

1. **Text Summarization** - Generate concise summaries using BART-large-CNN
2. **Question Answering** - Answer questions based on provided context using RoBERTa
3. **Named Entity Recognition** - Extract entities (Person, Organization, Location, etc.) from text
4. **Translation** - Translate English text to French, Spanish, or German

## Models Used

- **Summarization**: `facebook/bart-large-cnn`
- **Question Answering**: `deepset/roberta-base-squad2`
- **Named Entity Recognition**: `dslim/bert-base-NER`
- **Translation**:
  - English → French: `Helsinki-NLP/opus-mt-en-fr`
  - English → Spanish: `Helsinki-NLP/opus-mt-en-es`
  - English → German: `Helsinki-NLP/opus-mt-en-de`

## Installation

1. Clone or download this repository

2. Install the required dependencies:
```bash
pip install -r requirements.txt
```

3. (Optional) Set up your Hugging Face token:
   - Get your token from [Hugging Face Settings](https://huggingface.co/settings/tokens)
   - Create a `.env` file in the project root directory (same folder as `app.py`)
   - Add the following line to the `.env` file:
   ```
   HF_TOKEN=your_token_here
   ```
   - Replace `your_token_here` with your actual Hugging Face token
   - **Note**: The `.env` file should be in the same directory as `app.py`

## Usage

Run the Streamlit application:

```bash
streamlit run app.py
```

**Note**: If you encounter a PyTorch/Streamlit compatibility error, run with the file watcher disabled:

```bash
streamlit run app.py --server.fileWatcherType none
```

Alternatively, you can create a `.streamlit/config.toml` file with:
```toml
[server]
fileWatcherType = "none"
```

The application will open in your default web browser. Select a task from the sidebar and follow the on-screen instructions.

## How to Use

1. **Text Summarization**:
   - Select "Text Summarization" from the sidebar
   - Paste your text in the text area
   - Click "Run Summarization"

2. **Question Answering**:
   - Select "Question Answering" from the sidebar
   - Enter the context paragraph
   - Enter your question
   - Click "Run Question Answering"

3. **Named Entity Recognition**:
   - Select "Named Entity Recognition" from the sidebar
   - Paste your text
   - Click "Run NER"

4. **Translation**:
   - Select "Translation" from the sidebar
   - Choose target language (French/Spanish/German)
   - Enter English text
   - Click "Run Translation"

## Requirements

- Python 3.8 or higher
- Streamlit
- Transformers (Hugging Face)
- PyTorch
- Python-dotenv (for environment variables)

## Notes

- Models are cached after first load for faster subsequent runs
- The application requires an internet connection to download models on first use
- GPU is recommended for faster inference but not required

## License

This project is for educational purposes.

