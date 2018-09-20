ARG BRANCH=master
FROM metwork/mfcom-centos7-buildimage:${BRANCH} as yum_cache
ARG BRANCH
RUN echo -e "[metwork_${BRANCH}]\n\
name=Metwork Continuous Integration Branch ${BRANCH}\n\
baseurl=http://metwork-framework.org/pub/metwork/continuous_integration/rpms/${BRANCH}/centos7/\n\
gpgcheck=0\n\
enabled=1\n\
metadata_expire=0\n" >/etc/yum.repos.d/metwork.repo
ARG CACHEBUST=0
RUN yum --disablerepo=* --enablerepo=metwork_${BRANCH} -q list metwork-* 2>/dev/null |sort |md5sum |awk '{print $1;}' > /tmp/yum_cache

FROM metwork/mfcom-centos7-buildimage:${BRANCH}
COPY --from=yum_cache /etc/yum.repos.d/metwork.repo /etc/yum.repos.d/
COPY --from=yum_cache /tmp/yum_cache .
RUN yum -y install metwork-mfcom
