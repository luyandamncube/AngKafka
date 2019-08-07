import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { ChartComponent } from 'angular2-highcharts/index';
import { ChatService } from './chart.services';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  providers: [ChatService]
})
export class AppComponent implements OnInit, OnDestroy {
  messages = [];
  connection;
  message;
  options: Object;
  @ViewChild('chartVar') refObj: any;
  constructor(private chatService: ChatService) { }

  sendMessage() {
    this.chatService.sendMessage(this.message);
    this.message = '';
  }

  ngOnInit() {
    this.renderChart();
    this.connection = this.chatService.getLiveData1().subscribe(message => {
      this.messages.push(message);
      message["y"] = +message["y"];
      this.refObj.chart.series[0].addPoint(message, false);
      this.refObj.chart.redraw();
    })
    this.chatService.getLiveData2().subscribe(sampleMessage => {
      this.messages.push(sampleMessage);
      sampleMessage["y"] = +sampleMessage["y"];
      this.refObj.chart.series[0].addPoint({ x: sampleMessage["x"], y: null }, false);
      this.refObj.chart.series[1].addPoint(sampleMessage, false);
      this.refObj.chart.redraw();
    })

  }

  ngOnDestroy() {
    this.connection.unsubscribe();
  }

  renderChart() {
    this.options = {

      rangeSelector: {
        buttons: [{
          count: 1,
          type: 'minute',
          text: '1M'
        }, {
          count: 5,
          type: 'minute',
          text: '5M'
        }, {
          type: 'all',
          text: 'All'
        }],
        inputEnabled: false,
        selected: 0
      },

      title: {
        text: 'Live random data'
      },
      xAxis: {
        opposite: true
      },
      yAxis: { opposite: true },
      exporting: {
        enabled: false
      },

      series: [{
        name: 'Live data 1',
        data: []
      },
      {
        name: 'Live data 2',
        data: []
      }
      ]

    }
  }
  chart: Object;

  loadChart(chartInstance) {
    this.chart = chartInstance;
  }

}