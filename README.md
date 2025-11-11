<p>Code used to generate figures and tools described in Malkowska et al., 2025 Neural stem cell quiescence is actively maintained by the epigenome&nbsp;</p>
<p><strong>feat_annot.sh</strong> Uses bedmap op to annotate features with chromatin states based on the fraction of bases of the feature residing in a given state. Generates a csv file.</p>
<p><strong>coverage_over_states.sh </strong>Uses bedtools coverage to calculate and plot read coverage of a bam file over chromatin state annotation. Generates a pdf heatmap.</p>
