workflow kallisto {
  File fasta    
  File read1
  File read2
  String outdirname

  call index {
    input:
      FASTA=fasta
  }

  call quant {
    input:
      INDEX = index.indexFASTA,
      READ1 = read1,
      READ2 = read2,
      OUTDIR = outdirname
  }
}

task index {
  File FASTA
  
  command <<<
    kallisto index -i transcript_index ${FASTA}
  >>>
  
  output {
    File indexFASTA = "transcript_index"
  }
}

task quant {
  File INDEX
  File READ1
  File READ2
  String OUTDIR

  command <<<
    kallisto quant -o ${OUTDIR} -i ${INDEX} ${READ1} ${READ2}
  >>>

  output {
    File TAR = "abundance.tsv"
  }
}
