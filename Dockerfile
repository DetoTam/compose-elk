ARG ELK_VERSION
# Используем официальные образы ELK стека
FROM elasticsearch:${ELK_VERSION} as elasticsearch
FROM kibana:${ELK_VERSION} as kibana
FROM logstash:${ELK_VERSION} as logstash

RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Используем аргументы сборки
ARG ES_CONFIG
ARG ES_DATA
ARG ES_LOGS
ARG KBN_CONFIG
ARG KBN_LOGS
ARG LS_CONFIG
ARG LS_LOGS
ARG LS_PIPELINE
ARG LS_DATA
ARG LS_PATTERNS

# Устанавливаем переменные окружения
ENV ES_CONFIG=${ES_CONFIG} \
    ES_DATA=${ES_DATA} \
    ES_LOGS=${ES_LOGS} \
    KBN_CONFIG=${KBN_CONFIG} \
    KBN_LOGS=${KBN_LOGS} \
    LS_CONFIG=${LS_CONFIG} \
    LS_LOGS=${LS_LOGS} \
    LS_PIPELINE=${LS_PIPELINE} \
    LS_DATA=${LS_DATA} \
    LS_PATTERNS=${LS_PATTERNS} 

RUN mkdir -p "$ES_CONFIG" "$ES_DATA" "$ES_LOGS" \
    "$KBN_CONFIG" "$KBN_LOGS" \
    "$LS_CONFIG" "$LS_LOGS" "$LS_PIPELINE" "$LS_DATA" "$LS_PATTERNS" 
    
RUN chmod -R 777 "$ES_CONFIG" "$ES_DATA" "$ES_LOGS" \
    "$KBN_CONFIG" "$KBN_LOGS" \
    "$LS_CONFIG" "$LS_LOGS" "$LS_PIPELINE" "$LS_DATA" "$LS_PATTERNS"

# Опционально: устанавливаем владельца (если нужно)
# RUN chown -R elasticsearch:elasticsearch /etc/elasticsearch /usr/share/elasticsearch
# RUN chown -R kibana:kibana /etc/kibana /usr/share/kibana
# RUN chown -R logstash:logstash /etc/logstash /usr/share/logstash

CMD ["/bin/bash"]