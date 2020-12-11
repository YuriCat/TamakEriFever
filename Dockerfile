FROM gcr.io/kaggle-images/python

RUN git clone https://github.com/Kaggle/kaggle-environments.git && \
 cd kaggle-environments && \
 pip install . # GFootball environment.

RUN apt-get update -y && \
 apt-get install -y libsdl2-gfx-dev libsdl2-ttf-dev # Make sure that the Branch in git clone and in wget call matches !!

RUN git clone -b v2.8 https://github.com/google-research/football.git && \
 mkdir -p football/third_party/gfootball_engine/lib && \
 wget https://storage.googleapis.com/gfootball/prebuilt_gameplayfootball_v2.8.so -O football/third_party/gfootball_engine/lib/prebuilt_gameplayfootball.so && \
 wget https://gist.githubusercontent.com/RaffaeleMorganti/04192739d0a5a518ac253889eb83c6f1/raw/c09f3d602ea89e66daeda96574d966949a2896ce/11_vs_11_deterministic.py -O football/gfootball/scenarios/11_vs_11_deterministic.py && \
 wget https://gist.githubusercontent.com/RaffaeleMorganti/04192739d0a5a518ac253889eb83c6f1/raw/c09f3d602ea89e66daeda96574d966949a2896ce/football_action_set.py -O football/gfootball/env/football_action_set.py && \
 cd football && GFOOTBALL_USE_PREBUILT_SO=1 pip3 install .

RUN export OMP_NUM_THREADS=1
RUN ulimit -n 65536

COPY football/football_action_set_v2.py /opt/conda/lib/python3.7/site-packages/kaggle_environments/envs/football/football.py
COPY football/11_vs_11_kaggle_1000_500.py /opt/conda/lib/python3.7/site-packages/gfootball/scenarios/11_vs_11_kaggle_1000_500.py
COPY football/11_vs_11_kaggle_train.py /opt/conda/lib/python3.7/site-packages/gfootball/scenarios/11_vs_11_kaggle_train.py
