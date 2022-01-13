FROM rocker/shiny:3.6.3
RUN apt-get --allow-releaseinfo-change update \
    && apt-get update \
    && apt-get install libssl-dev unixodbc-dev curl gnupg2 libgdal-dev libudunits2-dev -y


RUN install2.r  devtools

RUN Rscript -e 'install.packages(c("shinyWidgets", "plotly", "lubridate", "shinycssloaders", "DT", "shinyFiles"), repos="https://cran.microsoft.com/")'

RUN Rscript -e 'install.packages(c("shinybusy","shinydashboard","dygraphs", "shinyFiles", "Amelia","openxlsx", "randomForest", "caret"), repos="https://cran.microsoft.com/")'

RUN Rscript -e 'install.packages(c("fastmap", "htmltools"), repos="https://cran.microsoft.com/")'

RUN Rscript -e 'install.packages(c("readxl", "qs", "Cubist", "gbm", "leaflet.extras"), repos="https://cran.microsoft.com/")'

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#Ubuntu 20.04
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17

RUN Rscript -e 'install.packages(c("odbc", "dbplyr", "rgdal", "sf", "janitor", "tidyr"), repos="https://cran.microsoft.com/")'


CMD ["bash"]


