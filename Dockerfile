FROM jupyter/all-spark-notebook:latest
RUN conda install boto3 pytest pytest-cov pytest-xdist pytest-timeout


RUN pip install --upgrade pip && pip install gluejobutils \
&&  pip install git+git://github.com/moj-analytical-services/etl_manager.git \ 
&& pip install git+git://github.com/moj-analytical-services/dataengineeringutils.git

COPY pysparkconf.py pysparkconf.py
COPY hdfs-site.xml /usr/local/spark/conf
COPY aptpackages aptpackages



ENV PYSPARK_SUBMIT_ARGS  '--packages com.amazonaws:aws-java-sdk:1.10.34,org.apache.hadoop:hadoop-aws:2.6.0 pyspark-shell'
RUN python pysparkconf.py

USER root
RUN apt-get update  && apt-get install -y $(cat aptpackages) && rm -rf /var/lib/apt/lists/*



COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
