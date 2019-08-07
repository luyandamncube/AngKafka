import { LiveChartPage } from './app.po';

describe('live-chart App', () => {
  let page: LiveChartPage;

  beforeEach(() => {
    page = new LiveChartPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
