#MOLGENIS walltime=05:59:00 mem=6gb ppn=6


#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string picardVersion
#string gcBiasMetricsJar
#string dedupBam
#string dedupBamIdx
#string indexFile
#string collectBamMetricsPrefix
#string tempDir
#string recreateInsertSizePdfR
#string rVersion
#string ngsUtilsVersion
#string capturingKit
#string seqType
#string picardJar
#string insertSizeMetrics
#string gcBiasMetrics
#string	project
#string logsDir 
#string groupname

#Load Picard module
${stage} "${picardVersion}"
${stage} "${rVersion}"
${stage} "${ngsUtilsVersion}"
${checkStage}

makeTmpDir "${gcBiasMetrics}"
tmpGcBiasMetrics="${MC_tmpFile}"

#Run Picard GcBiasMetrics
java -XX:ParallelGCThreads=4 -jar -Xmx4g "${EBROOTPICARD}/${picardJar}" "${gcBiasMetricsJar}" \
R="${indexFile}" \
I="${dedupBam}" \
O="${tmpGcBiasMetrics}" \
S="${tmpGcBiasMetrics}.summary_metrics.txt" \
CHART="${tmpGcBiasMetrics}.pdf" \
VALIDATION_STRINGENCY=STRICT \
TMP_DIR="${tempDir}"

echo -e "\nGcBiasMetrics finished succesfull. Moving temp files to final.\n\n"
mv "${tmpGcBiasMetrics}" "${gcBiasMetrics}"
mv "${tmpGcBiasMetrics}.pdf" "${gcBiasMetrics}.pdf"

"${recreateInsertSizePdfR}" \
--insertSizeMetrics "${insertSizeMetrics}" \
--pdf "${insertSizeMetrics}.pdf"
