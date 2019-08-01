FROM python:3.6-jessie

ENV TZ=America/Toronto

RUN apt-get update \
    && apt-get install -y cron \
    && apt-get autoremove -y

WORKDIR /root
RUN mkdir workspace
COPY ./scripts ./workspace/scripts
COPY ./requirements.txt ./workspace/requirements.txt
RUN pip install -qr ./workspace/requirements.txt
RUN chmod a+x ./workspace/scripts/main_script.py

RUN touch /etc/cron.d/cronpy
RUN echo "* * * * * root /usr/local/bin/python3 /root/workspace/scripts/main_script.py >> /var/log/main_script.log 2>&1" > /etc/cron.d/cronpy
CMD ["cron", "-f"]
