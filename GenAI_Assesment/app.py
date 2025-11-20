import streamlit as st
from transformers import pipeline
import os
import warnings
from dotenv import load_dotenv

# Suppress TensorFlow warnings
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
warnings.filterwarnings('ignore', category=UserWarning)
warnings.filterwarnings('ignore', category=FutureWarning)

# Suppress TensorFlow deprecation warnings
try:
    import tensorflow as tf
    tf.get_logger().setLevel('ERROR')
except ImportError:
    pass

# Load environment variables
load_dotenv()
HF_TOKEN = os.getenv("HF_TOKEN")

# Page configuration
st.set_page_config(
    page_title="Multi-Task NLP Assistant",
    page_icon="🤖",
    layout="wide"
)

# Title
st.title("🤖 Multi-Task NLP Assistant")
st.markdown("---")

# Sidebar for task selection
st.sidebar.title("📋 Select Task")
task = st.sidebar.radio(
    "Choose a task:",
    ["Text Summarization", "Question Answering", "Named Entity Recognition", "Translation"]
)

# Initialize models (cached to avoid reloading)
@st.cache_resource
def load_summarization_model():
    return pipeline(
        "summarization",
        model="facebook/bart-large-cnn",
        tokenizer="facebook/bart-large-cnn",
        token=HF_TOKEN if HF_TOKEN else None
    )

@st.cache_resource
def load_qa_model():
    return pipeline(
        "question-answering",
        model="deepset/roberta-base-squad2",
        tokenizer="deepset/roberta-base-squad2",
        token=HF_TOKEN if HF_TOKEN else None
    )

@st.cache_resource
def load_ner_model():
    return pipeline(
        "ner",
        model="dslim/bert-base-NER",
        tokenizer="dslim/bert-base-NER",
        grouped_entities=True,
        token=HF_TOKEN if HF_TOKEN else None
    )

@st.cache_resource
def load_translation_model(target_lang):
    models = {
        "French": "Helsinki-NLP/opus-mt-en-fr",
        "Spanish": "Helsinki-NLP/opus-mt-en-es",
        "German": "Helsinki-NLP/opus-mt-en-de"
    }
    return pipeline(
        "translation",
        model=models[target_lang],
        token=HF_TOKEN if HF_TOKEN else None
    )

# Main content area
if task == "Text Summarization":
    st.header("📝 Text Summarization")
    st.markdown("Enter your text below to generate a concise summary.")
    
    text_input = st.text_area(
        "Enter your text:",
        height=200,
        placeholder="Paste your paragraph or article here..."
    )
    
    if st.button("Run Summarization", type="primary"):
        if not text_input or text_input.strip() == "":
            st.error("Please enter text!")
        else:
            with st.spinner("Generating summary..."):
                try:
                    summarizer = load_summarization_model()
                    summary = summarizer(
                        text_input,
                        max_length=150,
                        min_length=50,
                        do_sample=False
                    )[0]["summary_text"]
                    
                    st.markdown("### Summary:")
                    st.markdown(f"**{summary}**")
                except Exception as e:
                    st.error(f"An error occurred: {str(e)}")

elif task == "Question Answering":
    st.header("❓ Question Answering")
    st.markdown("Enter a context paragraph and ask a question about it.")
    
    context_input = st.text_area(
        "Enter context/paragraph:",
        height=200,
        placeholder="Paste the context paragraph here..."
    )
    
    question_input = st.text_input(
        "Enter your question:",
        placeholder="What is your question about the context?"
    )
    
    if st.button("Run Question Answering", type="primary"):
        if not context_input or context_input.strip() == "":
            st.error("Please enter text!")
        elif not question_input or question_input.strip() == "":
            st.error("Please enter a question!")
        else:
            with st.spinner("Finding answer..."):
                try:
                    qa_model = load_qa_model()
                    result = qa_model(
                        question=question_input,
                        context=context_input,
                        top_k=1,
                        max_answer_len=100
                    )
                    
                    st.markdown("### Answer:")
                    st.markdown(f"**{result['answer']}**")
                    st.markdown(f"*Confidence Score: {result['score']:.4f}*")
                except Exception as e:
                    st.error(f"An error occurred: {str(e)}")

elif task == "Named Entity Recognition":
    st.header("🏷️ Named Entity Recognition")
    st.markdown("Extract named entities (Person, Organization, Location, etc.) from your text.")
    
    text_input = st.text_area(
        "Enter your text:",
        height=200,
        placeholder="Paste your text here to extract entities..."
    )
    
    if st.button("Run NER", type="primary"):
        if not text_input or text_input.strip() == "":
            st.error("Please enter text!")
        else:
            with st.spinner("Extracting entities..."):
                try:
                    ner_model = load_ner_model()
                    entities = ner_model(text_input)
                    
                    if entities:
                        st.markdown("### Extracted Entities:")
                        
                        # Group entities by type for better display
                        entity_dict = {}
                        for entity in entities:
                            entity_type = entity['entity_group']
                            if entity_type not in entity_dict:
                                entity_dict[entity_type] = []
                            entity_dict[entity_type].append({
                                'word': entity['word'],
                                'score': entity['score']
                            })
                        
                        # Display entities grouped by type
                        for entity_type, items in entity_dict.items():
                            st.markdown(f"#### {entity_type}:")
                            entity_list = []
                            for item in items:
                                entity_list.append(f"- **{item['word']}** (confidence: {item['score']:.4f})")
                            st.markdown("\n".join(entity_list))
                            st.markdown("")
                    else:
                        st.info("No entities found in the text.")
                except Exception as e:
                    st.error(f"An error occurred: {str(e)}")

elif task == "Translation":
    st.header("🌍 Translation")
    st.markdown("Translate English text to French, Spanish, or German.")
    
    target_language = st.selectbox(
        "Select target language:",
        ["French", "Spanish", "German"]
    )
    
    text_input = st.text_area(
        "Enter English text:",
        height=200,
        placeholder="Enter the text you want to translate..."
    )
    
    if st.button("Run Translation", type="primary"):
        if not text_input or text_input.strip() == "":
            st.error("Please enter text!")
        else:
            with st.spinner(f"Translating to {target_language}..."):
                try:
                    translator = load_translation_model(target_language)
                    translation = translator(text_input)[0]["translation_text"]
                    
                    st.markdown("### Translation:")
                    st.markdown(f"**{translation}**")
                except Exception as e:
                    st.error(f"An error occurred: {str(e)}")

# Footer
st.markdown("---")
st.markdown("**Multi-Task NLP Assistant** - Powered by Hugging Face Transformers")