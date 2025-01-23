FROM python:3.8.6-slim-buster



# Install any additional dependencies
RUN apt-get update && apt-get install -y \
    bash \
    gcc \
    make

 # Copy Kaldi installation
COPY ./kaldi_on_host /opt/kaldi

# Set Kaldi environment
ENV KALDI_ROOT=/opt/kaldi
ENV PATH=$PATH:$KALDI_ROOT/src/bin:$KALDI_ROOT/tools/openfst/bin:$KALDI_ROOT/src/fstbin:$KALDI_ROOT/src/gmmbin:$KALDI_ROOT/src/featbin:$KALDI_ROOT/src/lmbin:$KALDI_ROOT/src/sgmmbin:$KALDI_ROOT/src/sgmm2bin:$KALDI_ROOT/src/fgmmbin:$KALDI_ROOT/src/latbin:$KALDI_ROOT/src/nnetbin:$KALDI_ROOT/src/nnet2bin:$KALDI_ROOT/src/nnet3bin:$KALDI_ROOT/src/rnnlmbin:$KALDI_ROOT/src/kwsbin
ENV LC_ALL=C

WORKDIR /app

COPY requirements.txt .
# Upgrade pip
RUN pip install --upgrade pip
RUN pip install --timeout=1000 -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]



# # Use an official Python runtime as a parent image
# # FROM python:3.12.5
# FROM kaldiasr/kaldi:latest
#
# LABEL maintainer="Javid" \
#       project="Language Detection" \
#       tool="FastAPI"
#
# # Set the working directory in the container
# WORKDIR /app
#
# # Copy the requirements file into the container
# COPY requirements.txt .
#
# # RUN pip install --timeout=1000 -r requirements.txt
#
# RUN apt-get update && \
#     apt-get install -y --fix-missing python3-pip && \
#     pip3 install --upgrade pip && \
#     pip3 install --timeout=1000 -r requirements.txt && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*
#
# COPY . .
#
#
# # Configure environment variables for Kaldi
# ENV KALDI_ROOT=/opt/kaldi
# RUN echo "export KALDI_ROOT=/opt/kaldi" >> ~/.bashrc && \
#     echo "source /opt/kaldi/tools/config/common_path.sh" >> ~/.bashrc && \
#     echo "export PATH=\$KALDI_ROOT/src/bin:\$KALDI_ROOT/tools/openfst/bin:\$PATH" >> ~/.bashrc
# ENV PATH=$KALDI_ROOT/src/bin:$KALDI_ROOT/tools/openfst/bin:$PATH
#
#
#
# # Expose the port FastAPI runs on
# EXPOSE 8000
#
# # Command to run the FastAPI app
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
